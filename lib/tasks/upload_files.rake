require 'find'

namespace :upload_files do
    desc "upload files for employer registration"
	task employer_registration: :environment do
		log = MigrationLog.create({
			description: 'rake upload_files:employer_registration',
			start_at: DateTime.now
		})

        # path = File.join(Rails.root, "/test_files/employers/*")
		path = File.expand_path("employers/*", "~/fomema/migration_files")
		Dir[path].each do |file|
			filename = File.basename(file)
			sanitize_filename = ActiveRecord::Base.connection.quote(filename)
			sql = "select * from fomema_backup_portal.support_document_path where docdata = #{sanitize_filename}"
			support_document_paths = ActiveRecord::Base.connection.execute(sql)

			support_document_paths.each do |support_document_path|

				regid = support_document_path['regid']

				employer_sql = "select emp.id from fomema_backup_portal.employer_registration er 
				join employers emp on er.employer_code = emp.code
				where er.id = #{regid}"

				employers = ActiveRecord::Base.connection.execute(employer_sql)

				employers.each do |employer|
					employer = Employer.find(employer['id']) 
					created_at = employer.created_at
					upl = employer.uploads.create(created_at: created_at,updated_at: created_at)
					upl.documents.attach(io: File.open(file), filename: filename)
				end
			end
		end
		log.update({
			end_at: DateTime.now
		})
		puts 'done upload'
    end

    desc "upload files for foreign worker amendment"
	task fw_amendment: :environment do
		log = MigrationLog.create({
			description: 'rake upload_files:fw_amendment',
			start_at: DateTime.now
		})

		# path = File.join(Rails.root, "/test_files/foreign_workers/*")
		path = File.expand_path("foreign_workers/*", "~/fomema/migration_files")
		Dir[path].each do |file|
			filename = File.basename(file)
			sanitize_filename = ActiveRecord::Base.connection.quote(filename)
			sql = "select * from fomema_backup_portal.fw_amendment where doc_path = #{sanitize_filename}"
			fw_amendments = ActiveRecord::Base.connection.execute(sql)

			fw_amendments.each do |fw_amendment|
				if !fw_amendment['worker_code'].blank?
					worker_code = fw_amendment['worker_code']
					created_at = fw_amendment['created_date']

					foreign_worker = ForeignWorker.find_by(code: worker_code)
					upl = foreign_worker.uploads.create(created_at: created_at,updated_at: created_at)
					upl.documents.attach(io: File.open(file), filename: filename)
				end
			end
		end
		log.update({
			end_at: DateTime.now
		})
		puts 'done upload'
	end
	
	desc "upload files for bulletin"
	task bulletins: :environment do
		log = MigrationLog.create({
			description: 'rake upload_files:bulletins',
			start_at: DateTime.now
		})

		# path = File.join(Rails.root, "/test_files/bulletins/*")
		path = File.expand_path("bulletins/*", "~/fomema/migration_files")
		Dir[path].each do |file|
			filename = File.basename(file)
			sanitize_filename = ActiveRecord::Base.connection.quote("%#{filename}")
			sql = "select * from fomema_backup_nios.bulletin_master where filepath like #{sanitize_filename}"
			bulletins = ActiveRecord::Base.connection.execute(sql)

			bulletins.each do |bulletin|
				bulletin = Bulletin.find_by(reference_id: bulletin['bulletinid'])
				if !bulletin.blank?
					created_at = bulletin.created_at
					upl = bulletin.uploads.create(created_at: created_at,updated_at: created_at)
					upl.documents.attach(io: File.open(file), filename: filename)
				end
			end
		end
		log.update({
			end_at: DateTime.now
		})
		puts 'done upload'
    end
end