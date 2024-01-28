module Jim
    def get_biodata(order_item)
        foreign_worker = order_item.order_itemable
        foreign_worker = ForeignWorker.find(foreign_worker) if !foreign_worker.is_a?(ForeignWorker)

        # clear fw afis id for the next transaction
        foreign_worker.update({
            afis_id: nil,
            have_biodata: false
        })

        # get this week first date and last date
        today = Date.today
        week_first_date = today.at_beginning_of_week.strftime
        week_last_date = today.end_of_week.strftime
        # end

        existing_biodata = foreign_worker.biodata_responses.where("status_message = ? and created_at >= ? and created_at <= ?", "SUCCESS", week_first_date, week_last_date).order(created_at: :desc).first

        if existing_biodata
            # replace data from the existing biodata
            ok = foreign_worker.update({
                name: existing_biodata.worker_name,
                afis_id: existing_biodata.afis_id,
                plks_number:  existing_biodata.renewal_count_years.blank? ? foreign_worker.plks_number : existing_biodata.renewal_count_years,
                maid_online:  existing_biodata.pra_create_id,
                have_biodata: true
            })
        else
            ok = jim_biodata_get(foreign_worker)
        end

        return ok
    end

    def jim_biodata_get(foreign_worker)
        method = 'GetBiodata'

        ret = true

        url = URI.parse("http://#{ENV['JIM_HOST']}:#{ENV['JIM_PORT']}/fomema/getBiodata")

        header = {'Content-Type': 'application/json'}

        header_data = {
            applId: ENV["JIM_APP_ID"],
            applUserId: current_user.code,
            applReferenceId: "",
            clientMAC: "0",
            clientIP: request.ip,
            requestDateTime: DateTime.now.strftime("%F %H:%M"),
            clientComputerName:"",
        }

        request_data = {
            passportNo: foreign_worker['passport_number'],
            nationality: foreign_worker.country['code'],
            dateOfBirth: foreign_worker['date_of_birth'].strftime('%Y%m%d'),
            gender: foreign_worker['gender'] === 'M' ? 1 : 2 # 1 for Male, 2 for Female
        }

        request_msg = {
            header: header_data,
            request: request_data
        }

        # save request to database
        biodata_request = foreign_worker.biodata_requests.create({
            app_user_id: header_data[:applUserId],
            reference_id: '',
            client_mac: header_data[:clientMAC],
            client_ip: header_data[:clientIP],
            client_computer_name: '',
            request_datetime: header_data[:requestDateTime],
            gender: request_data[:gender],
            passport_no: request_data[:passportNo],
            nationality: request_data[:nationality],
            date_of_birth: request_data[:dateOfBirth]
        })

        header_data[:applTransactionId] = biodata_request.app_transaction_id
        # end save request to database

        begin
            request = Net::HTTP::Post.new(url.request_uri, header)
            response = Net::HTTP.start(url.host, url.port) {|http|
                http.read_timeout = SystemConfiguration.get("JIM_BIODATA_TIMEOUT", 30).to_i
                request.body = request_msg.to_json
                response = http.request(request)
            }
            log_api(method, request_msg, url, response.body, response.to_json)
        rescue Net::ReadTimeout => e
            ret = false
            log_api(method, request_msg, url, e.inspect ,e)
        rescue StandardError => e
            ret = false
            log_api(method, request_msg, url, e.inspect ,e)
        end

        if response && response.code == '200'
            # success
            response = JSON.parse(response.body)
            response_status = response['header']['statusMessage'].downcase
            afis_id = ''

            response_header = response['header']
            biodata_response = BiodataResponse.new({
                biodata_request_id: biodata_request.id,
                foreign_worker_id: foreign_worker.id,
                status_code: response_header['statusCode'],
                status_message: response_header['statusMessage'],
                description: response_header['description'],
                row_count: response_header['rowCount'],
            })

            have_response = response['response']

            if !have_response.blank?
                response_response = have_response[0]
                afis_id = response_response['afisId']

                # get 'afisId' (to store in data)
                foreign_worker.update({
                    name: response_response['workerName'].upcase,
                    afis_id: response_response['afisId'],
                    plks_number:  response_response['renewalCountYears'],
                    maid_online:  response_response['praCreateId'],
                    have_biodata: true
                })

                # store all data into database
                biodata_response.assign_attributes({
                    passport_number: response_response['passportNo'],
                    nationality: response_response['nationality'],
                    date_of_birth: response_response['dateOfBirth'],
                    gender: response_response['gender'],
                    worker_name: response_response['workerName'],
                    document_expiry_date: response_response['docExpiryDate'],
                    document_issue_authority: response_response['docIssueAuthority'],
                    application_number: response_response['applicationNumber'],
                    afis_id: response_response['afisId'],
                    ners_reason_code: response_response['nersReasonCode'],
                    date_of_arrival: response_response['dateOfArrival'],
                    employer_name: response_response['employerName'],
                    employer_id: response_response['employerName'],
                    employer_type: response_response['employerType'],
                    employer_address_1: response_response['employerAddress1'],
                    employer_address_2: response_response['employerAddress2'],
                    employer_address_3: response_response['employerAddress3'],
                    employer_address_4: response_response['employerAddress4'],
                    employer_postcode: response_response['employerPostcode'],
                    employer_city: response_response['employerCity'],
                    employer_state: response_response['employerState'],
                    employer_email: response_response['employerEmail'],
                    employer_phone_number: response_response['employerPhoneNo'],
                    ners_status: response_response['nersStatus'],
                    ners_message: response_response['nersMessage'],
                    fp_availability_status: response_response['fp_availability_status'],
                    fp_bio_sl: response_response['fp_biosl'],
                    fp_avail: response_response['fp_avail'],
                    transaction_id: response_response['transaction_id'],
                    renewal_count_years: response_response['renewalCountYears'],
                    pra_create_id: response_response['praCreateId'],
                })
            else
                foreign_worker.update({
                    afis_id: nil,
                    have_biodata: false
                })
            end

            biodata_response.save
        else
            # error in request
            ret = false
            foreign_worker.update({
                afis_id: nil,
                have_biodata: false
            })

            # store failed foreign worker into array
            # failed_request.push(foreign_worker.name)
        end

        # if failed_request.length > 0
        #     flash[:warning] = "#{failed_request.to_sentence} failed to retrieve biodata"
        # end
        return ret
    end
private
    def log_api(method, params, url, response, full_response)
        log_data = {
            :name => self.class.name,
            :api_type => 'REST_API',
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
