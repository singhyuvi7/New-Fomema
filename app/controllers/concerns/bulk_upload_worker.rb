module BulkUploadWorker

    def bulk_upload
    end

    def bulk_upload_preview
        unless params[:csv_file].nil?
            @file_path = params[:csv_file].path
        end

        render params[:page_layout]
    end

    def bulk_upload_store
        upload_count = 0

        ForeignWorker.transaction do
            foreign_workers = params[:selected_foreign_workers]
            @redirect_path = params[:redirect_path]
            employer_id = params[:employer_id] || @employer.id

            unless foreign_workers.nil?
                foreign_workers.each do |foreign_worker_data|
                    foreign_worker_data = JSON.parse(foreign_worker_data)
                    begin
                        foreign_worker = ForeignWorker.where({
                            gender: ForeignWorker::to_gender_code(foreign_worker_data[1]&.strip),
                            date_of_birth: convert_date(foreign_worker_data[2]&.strip),
                            passport_number: foreign_worker_data[3]&.strip.upcase,
                            country_id: Country::find_by(code: foreign_worker_data[4]&.strip).id,
                            status: "ACTIVE",
                        }).first_or_create do |fw|
                            fw.update({
                                name: foreign_worker_data[0]&.strip.upcase,
                                job_type_id: JobType::find_by(name: foreign_worker_data[5]&.strip).id,
                                arrival_date: convert_date(foreign_worker_data[6]&.strip),
                                pati: is_pati(foreign_worker_data[8]&.strip),
                                plks_number: foreign_worker_data[9]&.gsub(/\D/, '')&.strip,
                                employer_id: employer_id,
                                employer_supplement_id: current_user.employer_supplement_id
                            })
                        end
                    rescue Exception => e
                    end

                    if foreign_worker.try(:valid?)
                        upload_count += 1
                    end
                end
            end
        end

        redirect_to @redirect_path, flash: { notice: "Bulk upload (#{upload_count} foreign workers) done" }
    end

    def bulk_upload_template
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=bulk_upload_template.csv'
        render :template => "/external/worker_lists/bulk_upload_template.csv.erb"
    end

    def bulk_upload_specification
        send_file(
            "#{Rails.root}/public/files/PortalBatchWorkerUploadFileSpec.pdf",
            filename: "PortalBatchWorkerUploadFileSpec.pdf",
            type: "application/pdf"
        )
    end

    def is_pati(val)
        result = false
        result = true if val.downcase == 'yes'
        result = false if SystemConfiguration.get("PATI_#{site}").eql?("0")

        return result
    end

    def convert_date(string, format = "%d-%m-%Y")
        return nil if string.blank?
        Date.strptime(string, format)
    end

end
