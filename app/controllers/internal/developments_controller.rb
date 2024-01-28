class Internal::DevelopmentsController < InternalController

    skip_before_action :authenticate_internal_user!, only: [:jim_get_biodata]
    skip_before_action :verify_authenticity_token

    def jim_get_biodata
        success = {
            "header": {
                "applId": "FOMEMA",
                "applTransactionId": "ABCD12345",
                "applUserId": "FMM12345",
                "applReferenceId": "WRK12345",
                "clientDeviceSerial": "null",
                "clientMAC": "00:0c:29:d0:50:10",
                "clientIP": "192.168.1.1",
                "clientComputerName": "WINDOWS1234",
                "requestDateTime": "2017-02-27 13:10",
                "responseDateTime": "2017-03-07 15:51",
                "statusCode": "GWY0000",
                "statusMessage": "SUCCESS",
                "description": "One record found",
                "rowCount": 1
            },
            "response": [{
                "passportNo": "C1234567",
                "nationality": "CHN",
                "dateOfBirth": "19470710",
                "gender": "1",
                "workerName": "John Doe",
                "docExpiryDate": "20130801",
                "docIssueAuthority": "CHN",
                "applicationNumber": "APP12345",
                "afisId": "5896",
                "nersReasonCode": "",
                "dateOfArrival": "20160127",
                "employerName": "Facebook",
                "employerId": "22333",
                "employerType": "1",
                "employerAddress1": "Jalan SS 7/1",
                "employerAddress2": "JALAN BBT 1/6",
                "employerAddress3": "Address 3",
                "employerAddress4": "Address 4b",
                "employerPostcode": "40162",
                "employerCity": "1038",
                "employerState": "010",
                "employerEmail": "test@beans.com.my",
                "employerPhoneNo": "0173767555",
                "nersStatus": "200",
                "nersMessage": "Request OK",
                "fp_availability_status": "Y",
                "fp_biosl": "0",
                "fp_avail": "lt, ll, lm",
                "transaction_id": 'ASVDGE45654645',
                "renewalCountYears": rand(0..20),
                "praCreateId": "PRAON"
            }]
        }

        fw = ForeignWorker.where("passport_number = ?", params[:request][:passportNo]).first
        if fw
            success[:response][0] = success[:response][0].merge({
                passportNo: fw.passport_number,
                workerName: fw.name,
                afisId: fw.id,
                employerName: fw.employer.name,
            })
        end

        error = {
            "header": {
                "applId": "FOMEMA",
                "applTransactionId": "ABCD12345",
                "applUserId": "FMM12345",
                "applReferenceId": "WRK12345",
                "clientDeviceSerial": "null",
                "clientMAC": "00:0c:29:d0:50:10",
                "clientIP": "192.168.1.1",
                "clientComputerName": "WINDOWS1234",
                "requestDateTime": "2017-02-27 13:10",
                "responseDateTime": "2017-03-07 16:06",
                "statusCode": "GWY0004",
                "statusMessage": "ERROR",
                "description": "No record found",
                "rowCount": 0
            },
            "response": []
        }

        render json: success
    end

    def howden_calculator
        @request_data = JSON.parse(InsuranceService.decrypt(params[:param]))

        @response_data = {
            ORDER_CODE: @request_data["ORDER_CODE"],
            EMPLOYER_CODE: @request_data["EMPLOYER_CODE"],
            WORKER_LIST: [],
        }
        total_premium = total_gross_premium = total_stamp_duty =  total_sst = total_adminfees = total_adminfees_sst = 0.00
        @request_data["WORKER_LIST"].each do |worker|
            gross_premium = [50.0, 100.0, 150.0, 200.0].sample.to_f
            stamp_duty = (gross_premium * 0.1 * 100).round / 100.0
            sst = (gross_premium * 0.06 * 100).round / 100.0
            adminfees = [0.0, (gross_premium * 0.15 * 100).round / 100.0].sample.to_f
            adminfees_sst = (adminfees * 0.06 * 100).round / 100.0
            
            worker_return = worker.merge({
                INSURER: ["LIBERTY", "ETIQA"].sample,
                INS_PRODUCT: ["IG", "FWHS", "MAID", "IG&FWHS"].sample,
                GROSS_PREMIUM: gross_premium,
                STAMP_DUTY: stamp_duty,
                SST: sst,
                ADMINFEES: adminfees,
                ADMINFEES_SST: adminfees_sst,
                TOTAL_PREMIUM: gross_premium + stamp_duty + sst + adminfees + adminfees_sst,
            })
            @response_data[:WORKER_LIST] << worker_return
            total_premium += worker_return[:TOTAL_PREMIUM]
            total_gross_premium += worker_return[:GROSS_PREMIUM]
            total_stamp_duty += worker_return[:STAMP_DUTY]
            total_sst += worker_return[:SST]
            total_adminfees += worker_return[:ADMINFEES]
            total_adminfees_sst += worker_return[:ADMINFEES_SST]
        end
        @response_data.merge!({
            TOTAL_GROSS_PREMIUM: (total_gross_premium * 100.0).round / 100.0,
            TOTAL_STAMP_DUTY: (total_stamp_duty * 100.0).round / 100.0,
            TOTAL_SST: (total_sst * 100.0).round / 100.0,
            TOTAL_ADMINFEES: (total_adminfees * 100.0).round / 100.0,
            TOTAL_ADMINFEES_SST: (total_adminfees_sst * 100.0).round / 100.0,
            TOTALPREMIUM: (total_premium * 100.0).round / 100.0,
        })
        flash.keep
    end

    def howden_insurance_purchase
        @request_data = JSON.parse(InsuranceService.decrypt(params[:param]))

        @response_data = []
        @request_data["WORKER_LIST"].each do |worker|
            worker["INS_PRODUCT"].split('&').each.with_index(1) do |product, idx|
                @response_data << {
                    ORDER_CODE: @request_data["ORDER_CODE"],
                    EMPLOYER_CODE: @request_data["EMPLOYER_CODE"],
                    WORKER_ID: worker["WORKER_ID"],
                    STATUS: "ACTIVE",
                    INSURER: worker["INSURER"],
                    INS_PRODUCT: product,
                    POLICY_START_DATE: (Date.today + (idx - 1).year).strftime("%d/%m/%Y"),
                    POLICY_END_DATE: (Date.today + idx.year).strftime("%d/%m/%Y"),
                }
            end
        end
        flash.keep
    end

end