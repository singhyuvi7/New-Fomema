class External::SoapLaboratoriesController < ApplicationController
    soap_service namespace: "Laboratories"

    soap_action "RetrieveWorkerInfo",
        args: {
            application_id: :integer,
            passphrase:     :string,
            lab_code:       :string,
            worker_code:    :string,
            trans_id:       :integer
        },
        return: {
            return: {
                fomema_labws_response: {
                    labws_result:   :string,
                    labws_message:  :string,
                    labws_remarks:  :string,
                    labws_workerinfo: {
                        transid:    :integer,
                        workercode: :string,
                        name:       :string,
                        transdate:  :string,
                        sex:        :string,
                        passport:   :string,
                        country:    :string,
                        dob:        :datetime
                    }
                }
            }
        },
        to: :retrieve_worker_info

    def retrieve_worker_info
        @api_log = log_api("retrieve_worker_info", params, nil, nil, @user_id)
        cleanout_params_whitespace

        # In production, some clients/users will request in :xml format. It will give this error:
        # ActionView::MissingTemplate
        # Missing template external/soap_laboratories/submit_lab_transaction, application/submit_lab_transaction with {:locale=>[:en], :formats=>[:xml], :variants=>[], :handlers=>[:raw, :erb, :html, :builder, :ruby, :coffee, :jbuilder, :axlsx, :haml]}. Searched in:
        # To overcome this, I need to manually set it as html, instead of looking for it in xml.
        # Washout gem parses html files into xml as response, but the format in production causes a bug.
        formats.clear
        formats << :html

        # (Response) - Column cannot be empty.
            empty_parameters = [:application_id, :passphrase, :lab_code].map {|key| key if params[key].blank?}.compact.join(", ")

            if empty_parameters.present?
                @full_response  = render xml: merge_labws_remarks(response_code_hash("703"), empty_parameters), layout: false, content_type: "text/xml"
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            if params[:worker_code].blank? && params[:trans_id].blank?
                @full_response  = render xml: merge_labws_remarks(response_code_hash("703"), "Either worker_code or trans_id is needed"), layout: false, content_type: "text/xml"
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end
        begin
            check_for_exceeded_sizes

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            verify_soap_access

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            # (Response) - Worker info has been retrieved successfully.
                @response        = {
                    labws_result:   200,
                    labws_message:  response_code_message("200"),
                    labws_workerinfo: {
                        transid:    @transaction.code,
                        workercode: @worker.code,
                        name:       @worker.name,
                        transdate:  @transaction.transaction_date ? @transaction.transaction_date.strftime("%d-%m-%Y") : nil,
                        sex:        @worker.gender,
                        passport:   @worker.passport_number,
                        country:    @worker.country.name,
                        dob:        @worker.date_of_birth.strftime("%d-%m-%Y")
                    }
                }

                @full_response = render xml: nil, layout: false, content_type: "text/xml"
        rescue
            # (Response) - Internal system error.
                @full_response = render xml: response_code_hash("999"), layout: false, content_type: "text/xml"
        end

        @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
    end

    soap_action "SubmitLabTransaction",
        args: {
            application_id:             :integer,
            passphrase:                 :string,
            lab_code:                   :string,
            worker_code:                :string,
            specimen_receive_date:      :string,
            specimen_taken_date:        :string,
            blood_barcode_no:           :string,
            urine_barcode_no:           :string,
            blood_group:                :string,
            blood_group_others:         :string, # can be empty
            blood_rh:                   :string,
            hiv:                        :string,
            hbsag:                      :string,
            vdrl:                       :string,
            tpha:                       :string, # required if vdrl is Y
            malaria:                    :string,
            bfmp:                       :string, # required if malaria is Y
            opiates:                    :string,
            cannabis:                   :string,
            pregnancy:                  :string,
            serum_beta_hcg:             :string, # required if pregnancy is Y
            sugar:                      :string,
            sugar_milimoles:            :string, # required if sugar is Y
            albumin:                    :string,
            albumin_gram:               :string, # required if albumin is Y
            abnormal_reason:            :string, # required if there are any abnormal results
            confirmation_lab_results:   :string
         },
        return: {
            return: {
                fomema_labws_response: {
                    labws_result:       :string,
                    labws_message:      :string,
                    labws_remarks:      :string
                }
            }
        },
        to: :submit_lab_transaction

    def submit_lab_transaction
        @api_log = log_api("submit_lab_transaction", params, nil, nil, @user_id)
        time_now = Time.now
        cleanout_params_whitespace

        # In production, some clients/users will request in :xml format. It will give this error:
        # ActionView::MissingTemplate
        # Missing template external/soap_laboratories/submit_lab_transaction, application/submit_lab_transaction with {:locale=>[:en], :formats=>[:xml], :variants=>[], :handlers=>[:raw, :erb, :html, :builder, :ruby, :coffee, :jbuilder, :axlsx, :haml]}. Searched in:
        # To overcome this, I need to manually set it as html, instead of looking for it in xml.
        # Washout gem parses html files into xml as response, but the format in production causes a bug.
        formats.clear
        formats << :html

        # (Response) - Column cannot be empty.
            empty_parameters    = [:application_id, :passphrase, :lab_code, :worker_code, :specimen_receive_date, :specimen_taken_date, :blood_barcode_no, :urine_barcode_no, :blood_group, :hiv, :hbsag, :vdrl, :malaria, :opiates, :cannabis, :pregnancy, :sugar, :albumin, :confirmation_lab_results].select {|key| params[key].blank?}
            empty_parameters    << :blood_rh if params[:blood_group] != "OTHERS" && params[:blood_rh].blank?
            other_blood_group   = empty_parameters << :blood_group_others if params[:blood_group] == "OTHERS" && params[:blood_group_others].blank?
            empty_parameters    = empty_parameters.compact.join(", ")

            if empty_parameters.present?
                @full_response  = render xml: merge_labws_remarks(response_code_hash("703"), empty_parameters), layout: false, content_type: "text/xml"
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end
        begin
            check_for_exceeded_sizes

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            verify_soap_access

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            begin
                @transaction.build_laboratory_examination if @transaction.status == "EXAMINATION" && @transaction.laboratory_examination.blank?
                @laboratory_examination                 = @transaction.laboratory_examination
                @laboratory_examination                 = LaboratoryExamination.find_or_initialize_by(transaction_id: @transaction.id)
                @laboratory_examination.laboratory_id   = @transaction.laboratory_id
                @laboratory_examination.save unless @laboratory_examination.id?
            rescue
                # (Response) - Internal database error. Please contact FOMEMA.
                    @full_response  = render xml: response_code_hash("810"), layout: false, content_type: "text/xml"
                    @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                    return
            end

            check_for_transactional_errors

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            check_for_input_errors

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            check_for_sugar_albumin_errors

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            check_for_date_errors

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            check_for_other_errors

            if @return_error
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            if @transaction.is_blood_group_benchmark
                check_for_abo_discrepancy

                if @return_error
                    @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                    return
                end
            end

            # Do not save blood rh if blood group is other
            clear_blood_rh_for_other_blood_group

            remap_params = {
                specimen_receive_date:  :specimen_received_date,
                blood_barcode_no:       :blood_specimen_barcode,
                urine_barcode_no:       :urine_specimen_barcode,
                blood_group_others:     :blood_group_other,
                blood_rh:               :blood_group_rhesus,
                hiv:                    :elisa,
                serum_beta_hcg:         :pregnancy_serum_beta_hcg,
                sugar_milimoles:        :sugar_value,
                albumin_gram:           :albumin_value
            }

            key_value_map   = laboratory_exam_key_value_map
            lab_exam_params = params.to_unsafe_h.slice(:specimen_receive_date, :specimen_taken_date, :blood_barcode_no, :urine_barcode_no, :blood_group, :blood_group_others, :blood_rh, :hiv, :hbsag, :vdrl, :tpha, :malaria, :bfmp, :opiates, :cannabis, :pregnancy, :serum_beta_hcg, :sugar, :sugar_milimoles, :albumin, :albumin_gram, :abnormal_reason)
            remap_params.each {|old_key, new_key| lab_exam_params[new_key] = lab_exam_params.delete old_key}

            lab_exam_params.to_a.each do |key, value|
                mapping                 = key_value_map[key]
                next if mapping.blank?
                lab_exam_params[key]    = mapping[value]
            end

            lab_exam_params[:transmitted_at]            = time_now
            lab_exam_params[:laboratory_test_not_done]  = "NO"
            lab_exam_params[:web_service_indicator]     = true

            le_attributes__boolean  = lab_exam_params.with_indifferent_access.slice(:elisa, :hbsag, :vdrl, :tpha, :malaria, :bfmp, :opiates, :cannabis, :pregnancy, :pregnancy_serum_beta_hcg, :sugar, :albumin)
            le_attributes__values   = lab_exam_params.with_indifferent_access.slice(:sugar_value, :albumin_value)
            le_attributes__comments = lab_exam_params.with_indifferent_access.slice(:blood_group_other, :blood_group_rhesus_other, :abnormal_reason)

            laboratory_parameters = lab_exam_params.with_indifferent_access.except(:elisa, :hbsag, :vdrl, :tpha, :malaria, :bfmp, :opiates, :cannabis, :pregnancy, :pregnancy_serum_beta_hcg, :sugar, :albumin, :sugar_value, :albumin_value, :blood_group_other, :blood_group_rhesus_other, :abnormal_reason)

            if @laboratory_examination.update(laboratory_parameters)
                @laboratory_examination.save_examination_details_and_comments(
                    boolean_fields: le_attributes__boolean,
                    value_fields:   le_attributes__values,
                    comments:       le_attributes__comments
                )

                @laboratory_examination.reload.update(result: @laboratory_examination.result_of_exam ? "ABNORMAL" : "NORMAL")

                # For some reason, it is skipping laboratory_transmit_date. Need to make sure it definitely runs!
                @transaction.update(laboratory_transmit_date: time_now)

                unless @transaction.reload.laboratory_transmit_date?
                    @transaction.update(laboratory_transmit_date: time_now)
                end

                # (Response) - This lab result record has been submitted successfully.
                    @full_response  = render xml: response_code_hash("800"), layout: false, content_type: "text/xml"
            else
                # (Response) - There was an error updating the database. Please contact FOMEMA or retry this record in a different batch.
                    @full_response  = render xml: response_code_hash("825"), layout: false, content_type: "text/xml"
            end
        rescue
            # (Response) - Internal system error.
                @full_response  = render xml: response_code_hash("999"), layout: false, content_type: "text/xml"
        end

        @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
    end
private
    def response_code_message(code)
        {
            "800" => "This lab result record has been submitted successfully.",
            "801" => "The lab result record contains an invalid value. E.g. blood group of “K” is not acceptable.",
            "803" => "The foreign worker does not exist.",
            "804" => "The foreign worker is not allocated to you.",
            "806" => "This foreign worker has already been certified.",
            "807" => "Lab result already exists for this foreign worker.",
            "808" => "Please supply a reason for any lab result abnormalities.",
            "809" => "Foreign worker record incomplete in FOMEMA medical database, please contact FOMEMA.",
            "810" => "Internal database error. Please contact FOMEMA.",
            "812" => "Invalid “date of specimen received”.",
            "813" => "“Date of specimen received” is later than today’s date.",
            "814" => "“Date of specimen received” is earlier than worker registration/renewal date.",
            "816" => "Abnormal sugar findings found for “Normal” sugar.",
            "817" => "Abnormal albumin findings found for “Normal” albumin.",
            "818" => "Missing additional sugar findings for “Abnormal” sugar.",
            "819" => "Missing additional albumin findings for “Abnormal” albumin.",
            "820" => "Worker transaction (registration) has already expired (e.g. past 30 days since date of registration/renewal). Please contact FOMEMA for further information.",
            "821" => "Encountered a “Y” for TPHA when VDRL is “N”. This column must be “N”/Empty unless VDRL column is a “Y”.",
            "824" => "Legal declaration of confirmation of worker lab result must be “Y”.",
            "825" => "There was an error updating the database. Please contact FOMEMA or retry this record in a different batch.",
            "827" => "Reason (for abnormal lab results) is too long. Please limit to 1000 characters or less.",
            "828" => "Worker is pending for refund or already been refunded.",
            "829" => "Worker is blacklisted.",
            "830" => "Arrival Date for worker is empty.",
            "831" => "Worker is currently pending for special renewal replacement.",
            "832" => "The lab result contains an invalid value for Sugar Milimoles. The value must be more or equal to 15 mmol/l if sugar field is “Y”.",
            "833" => "Sugar Milimoles exceeded maximum value of 999.99.",
            "834" => "The lab result contains an invalid value for Albumin Gram. The value must be more or equal to 1 g/l if albumin field is “Y”.",
            "835" => "Albumin Gram exceeded maximum value of 99.99.",
            "836" => "Invalid “date of specimen taken”.",
            "837" => "“Date of specimen received” is earlier than “Date of specimen taken”.",
            "838" => "Blood/Urine barcode is too long. Please limit to 20 characters or less.",
            "839" => "Missing additional TPHA findings for ‘Reactive VDRL.",
            "840" => "Missing additional BFMP findings for ‘Positive’ Malaria.",
            "841" => "Missing additional Serum Beta-HCG findings for ‘Positive’ Pregnancy.",
            "842" => "Encountered a “Y” for BFMP when Malaria is “N”. This column must be “N”/Empty unless Malaria column is a “Y”.",
            "843" => "Encountered a “Y” for serum_beta_hcg when Pregnancy is “N”. This column must be “N”/Empty unless Pregnancy column is a “Y”.",
            "844" => "Transmission Unsuccessful. ABO(Rh) group discrepancy between current ABO(Rh) group with previous ABO(Rh) group. Please verify the result and transmit manually.",
            "845" => "Examination date is empty. Please contact the doctor to enter the examination date.",
            "846" => "Transmission of result is not allowed due to wrong gender.",
            "847" => "Gender amendment request is pending for approval. Transmission of result is not allowed at this moment. Please try again later.",
            "200" => "Worker info has been retrieved successfully.",
            "901" => "Invalid Application ID.",
            "902" => "Incorrect Passphrase.",
            "903" => "Invalid Lab Code.",
            "904" => "Inactive Lab Code.",
            "905" => "Lab code is not allowed to access web service.",
            "999" => "Internal system error.",
            "702" => "Maximum Field Size Exceeded.",
            "703" => "Column cannot be empty."
        }[code]
    end

    def response_code_hash(code)
        @return_error = true

        @response = {
            labws_result:   code.to_i,
            labws_message:  response_code_message(code)
        }

        return nil
    end

    def merge_labws_remarks(response, message)
        @response[:labws_remarks] = message
        return nil
    end

    def laboratory_exam_key_value_map
        positive_negative   = { "Y" => "true", "N" => "false" }

        {
            blood_group:                { "A" => "A", "B" => "B", "AB" => "AB", "O" => "O", "OTHERS" => "OTHER" },
            blood_group_rhesus:         { "Y" => "+VE", "N" => "-VE", "" => "" },
            elisa:                      positive_negative,
            hbsag:                      positive_negative,
            vdrl:                       positive_negative,
            tpha:                       positive_negative,
            malaria:                    positive_negative,
            bfmp:                       positive_negative,
            opiates:                    positive_negative,
            cannabis:                   positive_negative,
            pregnancy:                  positive_negative,
            pregnancy_serum_beta_hcg:   positive_negative,
            sugar:                      positive_negative,
            albumin:                    positive_negative,
        }.with_indifferent_access
    end

    def verify_soap_access
        # (Response) - Invalid Application ID.
        if params[:application_id] != "999"
            @full_response  = render xml: response_code_hash("901"), layout: false, content_type: "text/xml"
            return
        end

        # Laboratories
            @laboratory     = Laboratory.find_by(code: params[:lab_code])

            # (Response) - Invalid Lab Code.
            if @laboratory.blank?
                @full_response  = render xml: response_code_hash("903"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Incorrect Passphrase.
            if @laboratory.web_service_passphrase != Laboratory::passphrase_hash(params[:passphrase])
                @full_response  = render xml: response_code_hash("902"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Inactive Lab Code.
            if @laboratory.status != "ACTIVE"
                @full_response  = render xml: response_code_hash("904"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Lab code is not allowed to access web service.
            if !@laboratory.web_service?
                @full_response  = render xml: response_code_hash("905"), layout: false, content_type: "text/xml"
                return
            end

            @user_id        = @laboratory&.user&.id

        # Foreign Worker
            @worker     = ForeignWorker.find_by(code: params[:worker_code])

            # (Response) - The foreign worker does not exist.
            if @worker.blank? && action_name == "submit_lab_transaction"
                @full_response  = render xml: response_code_hash("803"), layout: false, content_type: "text/xml"
                return
            end

            @transaction    =
                if action_name == "retrieve_worker_info"
                    Transaction.find_by(code: params[:trans_id])
                elsif action_name == "submit_lab_transaction"
                    get_transaction
                end

            if action_name == "retrieve_worker_info"
                if @worker.present? && @transaction.blank?
                    @transaction    = get_transaction
                elsif @worker.blank? && @transaction.present?
                    @worker         = @transaction.foreign_worker
                end

                if @worker.blank?
                    @full_response  = render xml: response_code_hash("803"), layout: false, content_type: "text/xml"
                    return
                end
            end

            # (Response) - Foreign worker record incomplete in FOMEMA medical database, please contact FOMEMA.
            if @transaction.blank?
                @full_response  = render xml: response_code_hash("809"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Worker is pending for refund or already been refunded.
            if ["CANCEL_PENDING_PAYMENT", "CANCELLED"].include?(@transaction.status)
                @full_response  = render xml: response_code_hash("828"), layout: false, content_type: "text/xml"
                @api_log.update(response: @response, full_response: @full_response, requested_by: @user_id)
                return
            end

            # (Response) - The foreign worker is not allocated to you.
            if @transaction.laboratory_id != @laboratory.id
                @full_response  = render xml: response_code_hash("804"), layout: false, content_type: "text/xml"
                return
            end
    end

    def check_for_transactional_errors
        # (Response) - This foreign worker has already been certified.
        if ["REVIEW", "CERTIFIED"].include?(@transaction.status)
            @full_response  = render nil: response_code_hash("806"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Examination date is empty.
        if ["NEW"].include?(@transaction.status)
            @full_response  = render nil: response_code_hash("845"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Lab result already exists for this foreign worker.
        if @laboratory_examination.transmitted_at?
            @full_response  = render nil: response_code_hash("807"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Worker transaction (registration) has already expired (e.g. past 30 days since date of registration/renewal). Please contact FOMEMA for further information.
        if @transaction.expired_merts?
            @full_response  = render nil: response_code_hash("820"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Worker is blacklisted.
        if @worker.is_sp_transmit_blocked?
            @full_response  = render nil: response_code_hash("829"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Arrival Date for worker is empty. Remark from Tarmie, arrival date is optional during registration. NF-1767.
        # if !@worker.arrival_date?
            # @full_response  = render nil: response_code_hash("830"), layout: false, content_type: "text/xml"
            # return
        # end

        # (Response) - Worker is currently pending for special renewal replacement.
            # render soap: response_code_hash("831") and return if @worker.special_renewal? # Not in use because orders under special renewal can not generate transactions.

        # (Response) - Transmission of result is not allowed due to wrong gender.
        if @worker.previous_transaction_gender_different? or (@worker.has_pending_gender_amendment_approval? and @transaction.medical_examination_date.present?) or (@worker.gender != @transaction.fw_gender)
            @full_response  = render nil: response_code_hash("846"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Gender amendment request is pending for approval. Transmission of result is not allowed at this moment.
        if (@worker.has_pending_gender_amendment_order? or @worker.has_pending_gender_amendment_approval?) and !@transaction.medical_examination_date.present?
            @full_response  = render nil: response_code_hash("847"), layout: false, content_type: "text/xml"
            return
        end
    end

    def check_for_input_errors
        # Checking errors for
            required_yes_no     = params.slice(:hiv, :hbsag, :vdrl, :malaria, :opiates, :cannabis, :pregnancy, :sugar, :albumin).values.select {|param| !["Y", "N"].include?(param)}.present?
            optional_yes_no     = params.slice(:blood_rh, :serum_beta_hcg, :bfmp, :tpha).values.select {|param| !["Y", "N", nil, ""].include?(param)}.present?
            blood_group         = !["A", "AB", "B", "O", "OTHERS"].include?(params[:blood_group])

        # (Response) - The lab result record contains an invalid value. E.g. blood group of “K” is not acceptable.
        if required_yes_no || optional_yes_no || blood_group
            @full_response  = render xml: response_code_hash("801"), layout: false, content_type: "text/xml"
            return
        end

        # Double field inputs
            # (Response) - Missing additional TPHA findings for ‘Reactive VDRL.
            if params[:vdrl] == "Y" && params[:tpha].blank?
                @full_response  = render xml: response_code_hash("839"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Missing additional BFMP findings for ‘Positive’ Malaria.
            if params[:malaria] == "Y" && params[:bfmp].blank?
                @full_response  = render xml: response_code_hash("840"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Missing additional Serum Beta-HCG findings for ‘Positive’ Pregnancy.
            if params[:pregnancy] == "Y" && params[:serum_beta_hcg].blank?
                @full_response  = render xml: response_code_hash("841"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Encountered a “Y” for TPHA when VDRL is “N”. This column must be “N”/Empty unless VDRL column is a “Y”.
            if params[:tpha] == "Y" && params[:vdrl] == "N"
                @full_response  = render xml: response_code_hash("821"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Encountered a “Y” for BFMP when Malaria is “N”. This column must be “N”/Empty unless Malaria column is a “Y”.
            if params[:bfmp] == "Y" && params[:malaria] == "N"
                @full_response  = render xml: response_code_hash("842"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Encountered a “Y” for serum_beta_hcg when Pregnancy is “N”. This column must be “N”/Empty unless Pregnancy column is a “Y”.
            if params[:serum_beta_hcg] == "Y" && params[:pregnancy] == "N"
                @full_response  = render xml: response_code_hash("843"), layout: false, content_type: "text/xml"
                return
            end
    end

    def check_for_sugar_albumin_errors
        # Sugar & albumin values
            sugar_value     = params[:sugar_milimoles].to_f
            albumin_value   = params[:albumin_gram].to_f

            # (Response) - The lab result contains an invalid value for Sugar Milimoles.
            if params[:sugar_milimoles].present? && sugar_value < 15
                @full_response  = render xml: response_code_hash("832"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - The lab result contains an invalid value for Albumin Gram.
            if params[:albumin_gram].present? && albumin_value < 1
                @full_response  = render xml: response_code_hash("834"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Sugar Milimoles exceeded maximum value of 999.99.
            if sugar_value > 999.99
                @full_response  = render xml: response_code_hash("833"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Albumin Gram exceeded maximum value of 99.99.
            if albumin_value > 99.99
                @full_response  = render xml: response_code_hash("835"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Missing additional sugar findings for “Abnormal” sugar.
            if params[:sugar] == "Y" && params[:sugar_milimoles].blank?
                @full_response  = render xml: response_code_hash("818"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Missing additional albumin findings for “Abnormal” albumin.
            if params[:albumin] == "Y" && params[:albumin_gram].blank?
                @full_response  = render xml: response_code_hash("819"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Abnormal sugar findings found for “Normal” sugar.
            if params[:sugar] == "N" && sugar_value > 0
                @full_response  = render xml: response_code_hash("816"), layout: false, content_type: "text/xml"
                return
            end

            # (Response) - Abnormal albumin findings found for “Normal” albumin.
            if params[:albumin] == "N" && albumin_value > 0
                @full_response  = render xml: response_code_hash("817"), layout: false, content_type: "text/xml"
                return
            end
    end

    def check_for_date_errors
        # (Response) - Invalid “date of specimen received”.
            begin
                @received_date  = Time.strptime(params[:specimen_receive_date], "%d-%m-%Y %H:%M:%S") if params[:specimen_receive_date].length == 19

                if @received_date.strftime("%d-%m-%Y %H:%M:%S") != params[:specimen_receive_date]
                    @full_response  = render xml: response_code_hash("812"), layout: false, content_type: "text/xml"
                    return
                end
            rescue
                @full_response  = render xml: response_code_hash("812"), layout: false, content_type: "text/xml"
                return
            end

        # (Response) - Invalid “date of specimen taken.
            begin
                @taken_date     = Time.strptime(params[:specimen_taken_date], "%d-%m-%Y %H:%M:%S") if params[:specimen_taken_date].length == 19

                if @taken_date.strftime("%d-%m-%Y %H:%M:%S") != params[:specimen_taken_date]
                    @full_response  = render xml: response_code_hash("836"), layout: false, content_type: "text/xml"
                    return
                end
            rescue
                @full_response  = render xml: response_code_hash("836"), layout: false, content_type: "text/xml"
                return
            end

        # (Response) - “Date of specimen received” is later than today’s date.
        if @received_date > Time.now
            @full_response  = render xml: response_code_hash("813"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - “Date of specimen received” is earlier than worker registration/renewal date.
        if @received_date < @transaction.transaction_date
            @full_response  = render xml: response_code_hash("814"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - “Date of specimen received” is earlier than “Date of specimen taken”.
        if @received_date < @taken_date
            @full_response  = render xml: response_code_hash("837"), layout: false, content_type: "text/xml"
            return
        end
    end

    def check_for_other_errors
        # (Response) - Reason (for abnormal lab results) is too long. Please limit to 1000 characters or less.
        if params[:abnormal_reason].present? && params[:abnormal_reason].length > 1000
            @full_response  = render xml: response_code_hash("827"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Blood/Urine barcode is too long. Please limit to 20 characters or less.
        if params[:blood_barcode_no].length > 20 || params[:urine_barcode_no].length > 20
            @full_response  = render xml: response_code_hash("838"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Legal declaration of confirmation of worker lab result must be “Y”.
        if params[:confirmation_lab_results] != "Y"
            @full_response  = render xml: response_code_hash("824"), layout: false, content_type: "text/xml"
            return
        end

        # (Response) - Please supply a reason for any lab result abnormalities.
        any_abnormal = params.slice(:hiv, :hbsag, :tpha, :bfmp, :opiates, :cannabis, :serum_beta_hcg, :sugar, :albumin).values.include?("Y")

        if any_abnormal && params[:abnormal_reason].blank?
            @full_response  = render xml: response_code_hash("808"), layout: false, content_type: "text/xml"
            return
        end
    end

    def check_for_exceeded_sizes
        max_lengths = {
            application_id:             3,
            passphrase:                 100,
            lab_code:                   10,
            worker_code:                10,
            trans_id:                   14,
            sugar_milimoles:            6,
            albumin_gram:               5,
            blood_group_others:         255,
            blood_group:                6,
            blood_rh:                   1,
            hiv:                        1,
            hbsag:                      1,
            vdrl:                       1,
            tpha:                       1,
            malaria:                    1,
            bfmp:                       1,
            opiates:                    1,
            cannabis:                   1,
            pregnancy:                  1,
            serum_beta_hcg:             1,
            sugar:                      1,
            albumin:                    1,
            confirmation_lab_results:   1
        }

        any_exceeded = max_lengths.map do |key, value|
            key if params[key].present? && params[key].to_s.length > value
        end.compact

        if any_exceeded.present?
            @full_response = render xml: merge_labws_remarks(response_code_hash("702"), any_exceeded.join(", ")), layout: false, content_type: "text/xml"
        end
    end

    def cleanout_params_whitespace
        params.except("passphrase").each {|key, value| params[key] = value.to_s.strip.upcase }
    end

    def log_api(method, params, response, full_response, user_id)
        log_data = {
            name: self.class.name,
            api_type: "SOAP",
            request_type: "INCOMING",
            url: request.url,
            method: method,
            params: params,
            response: response,
            full_response: full_response,
            requested_by: user_id,
            ip_address: get_ip_address
        }

        ApiLog.create(log_data)
    end

    def get_transaction
        # Note, if you dont query this way, the db is too slow.
        date_id_status  = Transaction.where(foreign_worker_id: @worker.id).where.not(status: ["NEW_PENDING_APPROVAL", "REJECTED"]).pluck(:transaction_date, :id, :status).sort
        last_id         = date_id_status.last

        # Need to get correct transaction, if there are more than 1 transaction for that worker that year. Cannot depend on sorting.
        date_id_status.select! do |date, id, status|
            date > Date.today - 6.months && ["NEW", "EXAMINATION", "CERTIFICATION"].include?(status)
        end

        last_transaction    = date_id_status.last || last_id
        Transaction.find(last_transaction.second) if last_transaction.present?
    end

    def check_for_abo_discrepancy
        previous_transaction = @transaction.previous_transaction
        previous_lab_examination = previous_transaction.laboratory_examination
        previous_blood_rh = previous_lab_examination.blood_group_rhesus == '+VE' ? 'Y' : 'N'

        if params[:blood_group] != previous_lab_examination.blood_group || params[:blood_rh] != previous_blood_rh
            @full_response  = render nil: response_code_hash("844"), layout: false, content_type: "text/xml"
            return
        end
    end

    def clear_blood_rh_for_other_blood_group
        if params[:blood_group] == 'OTHERS'
            params[:blood_rh] = ''
        end
    end
end

# RetrieveWorkerInfo - Test code.
    # url = "http://niosws.localhost.com:3000/LabTransactionWS/services/LabTransactionWS?wsdl"; client = Savon::Client.new(wsdl: url, convert_request_keys_to: :none); transaction = Transaction.find(1); parameters = { application_id: 999, passphrase: transaction.laboratory.web_service_passphrase, lab_code: transaction.laboratory.code, worker_code: transaction.foreign_worker.code, trans_id: transaction.code }; response = client.call(:retrieve_worker_info, message: parameters); response.to_hash
    # request = client.build_request(:retrieve_worker_info, message: parameters);


# SubmitLabTransaction - Test code
    # url = "http://niosws.localhost.com:3000/LabTransactionWS/services/LabTransactionWS?wsdl"; transaction = Transaction.find(2); laboratory = transaction.laboratory; success_parameters = { application_id: 999, passphrase: laboratory.web_service_passphrase, lab_code: laboratory.code, worker_code: transaction.foreign_worker.code, specimen_receive_date: Time.now.strftime("%d-%m-%Y %H:%M:00"), specimen_taken_date: Time.now.strftime("%d-%m-%Y %H:%M:00"), blood_barcode_no: "BloodBarcodeDerp", urine_barcode_no: "UrineBarcodeDerp", blood_group: "A", blood_group_others: nil, blood_rh: "Y", hiv: "N", hbsag: "N", vdrl: "N", tpha: "N", malaria: "N", bfmp: "N", opiates: "N", cannabis: "N", pregnancy: "N", serum_beta_hcg: "N", sugar: "N", sugar_milimoles: nil, albumin: "N", albumin_gram: nil, abnormal_reason: nil, confirmation_lab_results: "Y" }; client = Savon::Client.new(wsdl: url, convert_request_keys_to: :none); response = client.call(:submit_lab_transaction, message: success_parameters); response.to_hash

    # list_of_parameters = {
        # application_id:             [100000, "", nil, 999].sample,
        # passphrase:                 ["Derp", "", nil, transaction.laboratory.web_service_passphrase],
        # lab_code:                   ["Derp", "", nil, transaction.laboratory.code],
        # worker_code:                ["Derp", "", nil, transaction.foreign_worker.code],
        # specimen_receive_date:      [(transaction.transaction_date - 2.months).strftime("%d-%m-%Y %H:%M:00"), (transaction.transaction_date + 3.months).strftime("%d-%m-%Y %H:%M:00"), "", nil, Time.now.strftime("%d-%m-%Y %H:%M:00")],
        # specimen_taken_date:        [(transaction.transaction_date - 2.months).strftime("%d-%m-%Y %H:%M:00"), (transaction.transaction_date + 3.months).strftime("%d-%m-%Y %H:%M:00"), "", nil, Time.now.strftime("%d-%m-%Y %H:%M:00")],
        # blood_barcode_no:           ["Derp", "", nil, "yesthisis21characters"].sample,
        # urine_barcode_no:           ["Derp", "", nil, "yesthisis21characters"].sample,
        # blood_group:                ["Derp", "A", "B", "AB", "O", "OTHER"].sample,
        # blood_group_others:         ["Derp", nil].sample,
        # blood_rh:                   [:Y, :N].sample,
        # hiv:                        [:Y, :N].sample,
        # hbsag:                      [:Y, :N].sample,
        # vdrl:                       [:Y, :N].sample,
        # tpha:                       [:Y, :N].sample,
        # malaria:                    [:Y, :N].sample,
        # bfmp:                       [:Y, :N].sample,
        # opiates:                    [:Y, :N].sample,
        # cannabis:                   [:Y, :N].sample,
        # pregnancy:                  [:Y, :N].sample,
        # serum_beta_hcg:             [:Y, :N].sample,
        # sugar:                      [:Y, :N].sample,
        # sugar_milimoles:            ["Derp", "", nil, -1, 10, 100, 500, 1000].sample,
        # albumin:                    [:Y, :N].sample,
        # albumin_gram:               ["Derp", "", nil, -1, 10, 50, 90, 100].sample,
        # abnormal_reason:            ["", nil, "LOREM IPSUM LOREM IPSUM"].sample,
        # confirmation_lab_results:   ["Derp", "", nil, "Y"].sample
    # };

    # request = client.build_request(:submit_lab_transaction, message: parameters)