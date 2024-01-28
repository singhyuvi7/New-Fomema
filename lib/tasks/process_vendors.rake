namespace :process_vendors do
    desc "insert vendor to finance system"
    task insert: :environment do
        include Sage

		log = MigrationLog.create({
			description: 'rake process_vendors:insert',
			start_at: DateTime.now
        })

        # 'Employer','Doctor','XrayFacility','Laboratory','ServiceProviderGroup'
        vendor_types = ['Doctor','XrayFacility','Laboratory','ServiceProviderGroup']

        vendor_types.each do |vendor_type|
            model = vendor_type.constantize
            vendors = model.all
            vendors.each do |vendor|
                @vendor_status = 'NEW_APPROVED'
                submit_vendor (vendor)
            end
        end

		log.update({
			end_at: DateTime.now
		})
		puts 'done insert'
    end

    desc "update vendor to finance system"
    task update: :environment do
        include Sage

		log = MigrationLog.create({
			description: 'rake process_vendors:update',
			start_at: DateTime.now
        })

        # 'Employer','Doctor','XrayFacility','Laboratory','ServiceProviderGroup'
        vendor_types = ['Doctor','XrayFacility','Laboratory','ServiceProviderGroup']

        vendor_types.each do |vendor_type|
            model = vendor_type.constantize
            vendors = model.all
            vendors.each do |vendor|
                @vendor_status = 'UPDATE_APPROVED'
                submit_vendor (vendor)
            end
        end

		log.update({
			end_at: DateTime.now
		})
		puts 'done update'
    end
end