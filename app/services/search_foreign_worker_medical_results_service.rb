class SearchForeignWorkerMedicalResultsService < ApplicationService
    def initialize(worker_codes, passport_numbers)
        @worker_codes       = worker_codes
        @passport_numbers   = passport_numbers
    end

    def call
        filter                      = Hash.new([])
        filter[:code]               = @worker_codes if @worker_codes.present?
        filter[:passport_number]    = @passport_numbers if @passport_numbers.present?
        search_workers(filter)
    end
private
    def search_workers(filter)
        # 2021-01-08 - From Peggie, Ops team want to only show results valid within 1 year.
        workers         = ForeignWorker.joins(:latest_transaction).where("foreign_workers.status = 'ACTIVE' and transactions.transaction_date >= '#{ Time.now - 1.year }'").includes(:country)
        query_build     = []
        worker_codes    = filter[:code].select(&:present?)
        passports       = filter[:passport_number].select(&:present?)
        workers         = workers.where("foreign_workers.code in (?) or foreign_workers.passport_number in (?)", worker_codes, passports)

        transactions    = Transaction.where(id: workers.map(&:latest_transaction_id)).map do |transaction|
            [transaction.id, { code: transaction.code, exam_date: transaction.medical_examination_date, cert_date: transaction.certification_date, status: transaction.displayed_status("Employer"), doc_approval_status: transaction&.transaction_verify_docs.last&.status }]
        end.to_h

        codes       = filter[:code]
        passports   = filter[:passport_number]
        results     = workers.map do |worker|
        trans       = transactions[worker.latest_transaction_id] || {}
        codes       -= [worker.code]
        passports   -= [worker.passport_number]

            [
                "#{ worker.name } (<b>#{ worker.code }</b>)",
                "#{ worker.passport_number } (<b>#{ worker.country&.name }</b>)",
                worker.date_of_birth&.strftime('%d/%m/%Y'), 
                ForeignWorker::GENDERS[worker.gender],
                trans[:code],
                trans[:exam_date]&.strftime('%d/%m/%Y'),
                trans[:cert_date]&.strftime('%d/%m/%Y'),
                "#{trans[:status]} <br><font color='red'><b>#{TransactionVerifyDoc::PORTAL_STATUSES[trans[:doc_approval_status]]}</b></font>"
            ]
        end

        results += codes.map {|code| [code, "", [""] * 5, "No Results Found"].flatten }
        results += passports.map {|passport| ["", passport, "", [""] * 4, "No Results Found"].flatten }
        results
    end
end