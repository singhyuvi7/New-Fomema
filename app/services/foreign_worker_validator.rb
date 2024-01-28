class ForeignWorkerValidator

    def initialize(employer, worker, site)
        @employer = employer
        @worker = worker
        @site = site

        @worker_name = @worker[0]&.strip.try(:upcase)
        @worker_gender = @worker[1]&.strip
        @worker_dob = @worker[2]&.strip
        @worker_passport = @worker[3]&.strip.try(:upcase)
        @worker_country = @worker[4]&.strip
        @worker_job_type = @worker[5]&.strip
        @worker_arrival_date = @worker[6]&.strip
        @worker_worker_code = @worker[7]&.strip.try(:upcase)
        @worker_pati = @worker[8]&.strip
        @worker_plks = @worker[9]&.strip

        @errors = Array.new
    end

    def validate
        validate_name
        validate_gender
        validate_dob
        validate_passport
        validate_country
        validate_job_type
        # validate_arrival_date
        validate_worker_code
        validate_pati
        validate_plks

        output
    end

    def output
        status = 'ok'

        unless valid?
            status = 'error'
        end

        output = {
            'status' => status,
            'output' => badge_output
        }

    end

    def badge_output
        error_html = ""

        unless @errors.empty?
            @errors.each do |error|
                error_html << "<button type='button' class='btn btn-sm btn-danger mb-2 mr-2' data-toggle='tooltip' title='#{error[:message]}' >"
                error_html << "#{error[:code]}"
                error_html << "</button>"
            end

            return error_html.html_safe
        end

        return ok_html = "<button type='button' class='btn btn-sm btn-success mb-2 mr-2' data-toggle='tooltip' title='OK' >0</button>".html_safe
    end

    def string_output
        unless @errors.empty?
            return @errors.join(",")
        end

        return 0
    end

    def validate_name

        if @worker_name.blank?
            @errors.push({:code => -10, :message => 'Worker Name is empty'})
            return
        end

        if @worker_name.length > 50
            @errors.push({:code => -11, :message => 'Worker Name must not more than 50 characters'})
        end

        # check special chars

        unless @worker_name.match("^[a-zA-Z0-9@&.'()-_/\s]*$")
            @errors.push({:code => -12, :message => 'Worker Name must not contains special characters'})
        end

    end

    def validate_gender

        if @worker_gender.blank?
            @errors.push({:code => -13, :message => 'Gender is empty'})
            return
        end

        if ['m','f'].exclude? @worker_gender.downcase
            @errors.push({:code => -14, :message => 'Gender is invalid'})
        end

    end

    def validate_dob
        if @worker_dob.blank?
            @errors.push({:code => -15, :message => 'Date Of Birth is empty'})
            return
        end

        unless valid_date?(@worker_dob)
            @errors.push({:code => -16, :message => 'Date Of Birth must in DD-MM-YYYY format'})
            return
        end

        if future_date?(@worker_dob)
            @errors.push({:code => -30, :message => 'Date Of Birth is Future Date'})
        end
    end

    def validate_passport
        if @worker_passport.blank?
            @errors.push({:code => -17, :message => 'Passport No. is empty'})
            return
        end

        if @worker_passport.length > 20
            @errors.push({:code => -18, :message => 'Passport No must not more than 20 characters'})
        end

        # check special chars
        unless @worker_passport.index( /[^[:alnum:]]/ ).nil?
            @errors.push({:code => -19, :message => 'Passport No must not contains special characters'})
        end

        return nil unless valid_date?(@worker_dob) # From Joey -> Must check here, because validate_unique is also using the method string_to_date, which will throw an error if dob is in wrong format. No need to push error code -16, because there is a previous method, validate_dob which has already pushed it.

        # check unique
        # foreign_worker = ForeignWorker.where(passport_number: @worker_passport).first
        # unless foreign_worker.nil?
        #     @errors.push({:code => -99, :message => 'Passport No is not unique'})
        # end
        validate_unique
    end

    def validate_country
        if @worker_country.blank?
            @errors.push({:code => -20, :message => 'Country Code is empty'})
            return
        end
        country = Country::where(code: @worker_country).first
        if country.nil?
            @errors.push({:code => -21, :message => 'Country Code is invalid'})
        end
    end

    def validate_job_type
        if @worker_job_type.blank?
            @errors.push({:code => -22, :message => 'Job Type is empty'})
            return
        end
        job_type = JobType::where(name: @worker_job_type).first
        if job_type.nil?
            @errors.push({:code => -23, :message => 'Job Type is invalid'} )
        end
        # if @worker_job_type.downcase === 'domestic' && @employer.employer_type.name.downcase != 'maid online'
        #     @errors.push({:code => -34, :message => 'Job Type DOMESTIC only allowed for Maid Online employer'} )
        # end
    end

    def validate_arrival_date
        # if @worker_arrival_date.blank?
        #     @errors.push({:code => -24, :message => 'Arrival Date is empty'} )
        #     return
        # end
        unless valid_date?(@worker_arrival_date)
            @errors.push({:code => -25, :message => 'Arrival Date must in DD-MM-YYYY format'})
            return
        end
        if future_date?(@worker_arrival_date)
            @errors.push({:code => -33, :message => 'Arrival Date is Future Date'})
        end
    end

    def validate_worker_code

        # if @worker_worker_code.blank?
        #     @errors.push({:code => -26, :message => 'Worker Code is invalid'})
        #     return
        # end

        return if @worker_worker_code.blank?

        first_char = @worker_worker_code.slice(0)

        unless first_char == 'W'
            @errors.push({:code => -26, :message => 'Worker Code is invalid '})
        end

        if @worker_worker_code.length != 10
            @errors.push({:code => -29, :message => 'Worker Code must be 10 characters'})
        end

    end

    def validate_pati

        if @worker_pati.blank?
            @errors.push({:code => -27, :message => 'PATI is empty'})
            return
        end

        if ['yes','no'].exclude? @worker_pati.downcase
            @errors.push({:code => -28, :message => 'PATI is invalid'})
        end
    end

    def validate_plks
        if @worker_plks.blank?
            @errors.push({:code => -31, :message => 'PLKS No. is empty'})
            return
        end

        if @worker_plks.length > 2 || !(@worker_plks !~ /\D/) || @worker_plks.to_i < 0 || @worker_plks.to_i > 99
            @errors.push({:code => -32, :message => 'PLKS No. is invalid'})
        end
    end

    def validate_unique
        if @site == 'PORTAL'
            foreign_worker = ForeignWorker.where(passport_number: @worker_passport).first
            unless foreign_worker.nil?
                @errors.push({:code => -99, :message => 'Worker already registered'})
            end
        else
            if ForeignWorker.joins(:country).where("foreign_workers.passport_number = ? and foreign_workers.date_of_birth = ? and countries.code = ? and foreign_workers.gender = ? and foreign_workers.status = 'ACTIVE'", @worker_passport, string_to_date(@worker_dob), @worker_country, @worker_gender).count > 0
                @errors.push({:code => -99, :message => 'Worker already registered'})
            end
        end
    end

    private

    def valid?
        valid = true

        unless @errors.empty?
            valid = false
        end

        valid
    end

    def valid_date?(string, format="%d-%m-%Y")
        Date.strptime(string, format) rescue false
    end

    def string_to_date(string)
        Date.strptime(string, "%d-%m-%Y")
    end

    def future_date?(date_string)
        return string_to_date(date_string).future?
    end

end