module Report
    class MyimmsErrorReportService
        attr_reader :query_date

        def initialize(query_date)
            @query_date    = query_date
        end

        def self.headers
            [
                'TRANS_ID',
                'PASSPORT_NO',
                'NATIONALITY',
                'MEDICAL_STATUS',
                'SEND_DATE',
                'QUEUE_OP',
                'MYIMMS_REPLY',
                'MYIMMS_ERROR'
            ]
        end

        def csv_result
            csv             = [MyimmsErrorReportService.headers]
            myimms_errors   = set_myimms_errors_data

            if myimms_errors.present?
                myimms_errors.each do |myimms_error|
                    csv << [
                        myimms_error.txn_id,
                        myimms_error.doc_no,
                        myimms_error.nat,
                        myimms_error.med_sts,
                        myimms_error.created_at.strftime("%d-%m-%Y %l:%M:%S"),
                        myimms_error.sts_ind,
                        myimms_error.res_status,
                        myimms_error.response
                    ]
                end
            end

            csv
        end

        def result
            set_myimms_errors_data
        end

        private

        def set_myimms_errors_data
            @myimms_errors  = MyimmsRequest.where(created_at: @query_date.beginning_of_day..@query_date.end_of_day)
                                .joins(
                                    :myimms_transaction, 
                                    :myimms_response, 
                                    myimms_transaction: [:transactionz]
                                )
                                .where.not(myimms_transactions: {status: '1'})
                                .order(created_at: :asc)
                                .select(
                                    :txn_id, 
                                    :doc_no, 
                                    :nat, 
                                    :med_sts, 
                                    :created_at, 
                                    :sts_ind, 
                                    'myimms_responses.status as res_status', 
                                    'myimms_responses.response as response'
                                )
        end

    end
end
