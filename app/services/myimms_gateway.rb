class MyimmsGateway < ApplicationService

    def initialize(ids,submit_type = nil, final_result = nil)
        @ids = ids
        @submit_type = submit_type
        @final_result = final_result
    end

    def call
        @idArr = @ids.is_a?(String) ? @ids.split(',') : @ids

        @type = @submit_type
        @batch_list = generate_batch_list
        @batch_list = @batch_list.reject { |item| item.blank? }
        if @batch_list.blank?
            return OpenStruct.new({
                success: false,
                flash: "Failed to submit to JIM"
            })
        else
            request
        end
    end

    def request

        return_obj = {
            success: false,
            flash: ''
        }
        method = 'IMM_SEND'
        url = URI.parse(ENV['IMI_GATEWAY_URL'])
        header = {'Content-Type': 'application/json'}

        begin
            myimms = Myimm.new
            myimms.save

            myimms_request_arr = {}

            @batch_list.each do |item|

                myimms_request = MyimmsRequest.new
                myimms_request.myimm_id = myimms.id
                myimms_request.myimms_transaction_id = Transaction.where(:code => item[:txn_id]).first.myimms_transaction.id
                myimms_request.txn_id = item[:txn_id]
                myimms_request.doc_no = item[:doc_no]
                myimms_request.nat = item[:nat]
                myimms_request.dob = item[:dob]
                myimms_request.name = item[:name]
                myimms_request.sex = item[:sex]
                myimms_request.med_dt = item[:med_dt]
                myimms_request.med_sts = item[:med_sts]
                myimms_request.src_ind = item[:src_ind]
                myimms_request.modify_dt = item[:modify_dt]
                myimms_request.sts_ind = item[:sts_ind]
                myimms_request.st_ind = item[:st_ind]
                myimms_request.save

                myimms_request_arr = myimms_request_arr.merge({
                    :"#{item[:txn_id]}" => myimms_request.id
                })
            end

            request_msg = {
                batch_code: myimms.batch_code,
                batch_count: @batch_list.count,
                batch_list: @batch_list
            }

            # for http
            # request = Net::HTTP::Post.new(url.request_uri, header)
            # response = Net::HTTP.start(url.host, url.port) {|http|
            #   http.read_timeout = ENV["JIM_TIMEOUT"].to_i
            #   request.body = request_msg.to_json
            #   response = http.request(request)
            # }
            ## end http

            ## for https
            https = Net::HTTP.new(url.host, url.port);
            https.use_ssl = true
            https.verify_mode = OpenSSL::SSL::VERIFY_NONE
            https.read_timeout = ENV["JIM_TIMEOUT"].to_i

            request = Net::HTTP::Post.new(url)
            request["Content-Type"] = "application/javascript"

            form_data = [['jsondata', request_msg.to_json]]

            request.set_form form_data, 'multipart/form-data'
            response = https.request(request)
            ## end for https
            log_api(method, request_msg, url, response.body, response)

        rescue Net::ReadTimeout => e
            log_api(method, request_msg, url, e.inspect ,e)
            generate_failed_response(myimms_request_arr,e)
            return_obj[:flash] = "Failed to submit to JIM"
            return OpenStruct.new(return_obj)
        rescue StandardError => e
            log_api(method, request_msg, url, e.inspect ,e)
            generate_failed_response(myimms_request_arr,e)
            return_obj[:flash] = "Failed to submit to JIM"
            return OpenStruct.new(return_obj)
        end

        if response.nil?
            response_body = response
        else
            response_body = response.body
        end

        if response && response.code == '200'
            begin
                response_body = Hash.from_xml(response.body)
                response_items = response_body['response']['item']
                response_items = [response_items] unless response_items.kind_of?(Array)
                response_items.each do |response_item|
                    response_txn_id = response_item['txn_id']
                    response_result = response_item['result']
                    batch_item = @batch_list.find { |item| item[:txn_id] == response_txn_id }

                    transaction = Transaction.find_by_code(response_txn_id)
                    transaction_id = transaction&.id
                    imm_transaction = MyimmsTransaction.where(:transaction_id => transaction_id).first

                    if !batch_item.blank? && batch_item[:sts_ind] == 'I'
                        transaction.is_imm_insert = response_result == '1' ? true : false
                        transaction.save
                    end

                    if imm_transaction
                        result_status = response_result == '1' ? '1' : '0'
                        imm_transaction.update({status: result_status,updated_at: Time.now})

                        myimms_response = MyimmsResponse.new
                        myimms_response.myimms_request_id = myimms_request_arr[:"#{response_txn_id}"]
                        myimms_response.response = response_item
                        myimms_response.status = response_result
                        myimms_response.save
                    end
                end

                return_obj[:success] = true
                return_obj[:flash] = "Submit to JIM successfully"
            rescue
                error_msg = "Failed to submit to JIM"
                generate_failed_response(myimms_request_arr,error_msg)
                return_obj[:flash] = error_msg
            end
        else
            error_msg = "Failed to submit to JIM"
            generate_failed_response(myimms_request_arr,error_msg)
            return_obj[:flash] = error_msg
        end

        return OpenStruct.new(return_obj) 
    end

    def generate_batch_list
  
        batch_list = @idArr.map do |id|
            transaction = Transaction.find(id)

            myimms_transaction = MyimmsTransaction.where(:transaction_id => id).first

            if myimms_transaction.blank?
                myimms_transaction = MyimmsTransaction.new
                myimms_transaction.transaction_id = id
                myimms_transaction.status = 0
                myimms_transaction.save
            end

            # check if foreign worker is block
            foreign_worker = transaction.foreign_worker
            if foreign_worker.blocked
                # disallow to send to JIM
                myimms_transaction.status = '98'
                myimms_transaction.save

                nil
            elsif transaction.is_imm_blocked
                # block labuan cases
                myimms_transaction.status = '96'
                myimms_transaction.save

                nil
            else
                ## default to fail whenever request to imm
                myimms_transaction.status = 0
                myimms_transaction.save

                ## update is_imm_insert to true if the transaction has duplicate error and is_imm_insert is false
                if transaction.last_myimms_response_has_duplicate_error?
                    transaction.is_imm_insert = true
                    transaction.save
                end

                med_sts = @final_result.blank? ? transaction.final_result.try(:upcase) : @final_result
                sts_ind = @type.blank? ? (transaction.is_imm_insert == true ? 'U' : 'I') : @type
                batch_item = {
                    txn_id: transaction.code,
                    doc_no: transaction&.fw_passport_number,
                    nat: transaction&.fw_country&.code,
                    dob: transaction&.fw_date_of_birth.try(:strftime,'%Y%m%d'),
                    name: transaction&.fw_name,
                    sex: transaction&.fw_gender === 'M' ? 1 : 2, # 1 for Male, 2 for Female
                    med_dt: transaction.medical_examination_date? ? transaction.medical_examination_date.try(:strftime,'%Y%m%d') : '',
                    med_sts: med_sts == 'SUITABLE' ? 1 : 0, # 0 for Unfit, 1 for Fit
                    src_ind: 'F',
                    modify_dt: Date.current.strftime('%Y%m%d%H%M'),
                    sts_ind: sts_ind, # I for insert, U for update
                    st_ind:  transaction.doctor.state.code === 'G' ? 'L' : 'O' # L for labuan, O for others
                }
                batch_item
            end
        end

        batch_list = batch_list.compact

        batch_list
    end

    def generate_failed_response(myimms_request_arr,error)
        myimms_request_arr.each do |key,value|
            myimms_response = MyimmsResponse.new
            myimms_response.myimms_request_id = value
            myimms_response.response = error
            myimms_response.status = '0'
            myimms_response.save
        end
    end

    def log_api(method, params, url, response, full_response)
        log_data = {
            :name => self.class.name,
            :api_type => 'SOAP',
            :request_type => 'OUTGOING',
            :url => url,
            :method => method,
            :params => params,
            :response => response,
            :full_response => full_response,
        }

        api_log = ApiLog.create(log_data)
    end
end