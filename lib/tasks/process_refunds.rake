namespace :process_refunds do

    desc "process refunds to finance system manually"
    task run: :environment do
        include Sage

		log = MigrationLog.create({
			description: 'rake process_refunds:run',
			start_at: DateTime.now
        })

        Refund.where(:status => 'PENDING_SEND').each do |refund|
            if refund.unutilised == true
                submit_special_refund_collection(refund)

                if @is_success == true
                    submit_refund (refund)
                end
            else
                submit_refund (refund)
            end
        end

		log.update({
			end_at: DateTime.now
		})
		puts 'done process'
    end
end