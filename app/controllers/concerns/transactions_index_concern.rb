module TransactionsIndexConcern
    def transactions_index_parameter_checking_and_cookies
    # For radiologists only. NF-1882
        # Only redirect if it's Radiologist, has no parameters & has cookies.
        if ["Radiologist"].include?(current_user.userable_type) && params.except(:action, :controller).blank? && session[:cookied_radiologist_path].present?
            redirect_to "#{ request.path }?#{ session[:cookied_radiologist_path] }" and return
        # Save cookie if there are params, otherwise will infinite loop.
        elsif ["Radiologist"].include?(current_user.userable_type) && params.except(:action, :controller).present?
            session[:cookied_radiologist_path] = request.url.split("?")[1]
        end

        # Set transaction_date_start to 1 year, if not set already. Cannot be left blank.
        if params[:transaction_date_start].present?
            trans_date = params[:transaction_date_start].to_date
        else
            trans_date = Date.today - 1.years
            params[:transaction_date_start] = Date.today - 1.years
        end

        # Only limit to 1 year (explicitly set) if not Employer. Meaning only employers can see dates further than 1 year.
        if trans_date < Date.today - 1.years && ["Doctor", "Laboratory", "XrayFacility", "Radiologist"].include?(current_user.userable_type)
            trans_date = Date.today - 1.years
            params[:transaction_date_start] = Date.today - 1.years
        end

        return trans_date
    end

    def transactions_index_transactions_list(transactions)
        # For radiologists only. NF-1882
        if ["Radiologist"].include?(current_user.userable_type)
            params[:per] = 1000 if params[:per].blank?

            transaction_ids = transactions.select("transactions.id id, xray_examinations.radiologist_assigned_at assigned_date,"\
            "case when transactions.xray_transmit_date is null and transactions.ignore_expiry is not true and transactions.status in ('NEW', 'EXAMINATION') and "\
            "(transactions.medical_examination_date + INTERVAL '30 day' < CURRENT_DATE is true or (transactions.medical_examination_date is null and transactions.expired_at < CURRENT_DATE)) "\
            "then 1 else 0 end merts_expiry_indicator"\
            "").joins(:xray_examination).order("merts_expiry_indicator asc, assigned_date asc")
        else
            transaction_ids = transactions.select("transactions.id, transactions.updated_at").order(updated_at: :desc)
        end

        @trans_ids      = transaction_ids.page(params[:page]).per(get_per).without_count

        # Retrieving transactions only by ID. Makes this from 1x to 100x as fast. (100x if the queries are complex, it could make a 500ms query to a 120s query)
        transactions    = Transaction.where(id: @trans_ids.map(&:id))
        transactions    = transactions.includes(:xray_examination)  if ["XrayFacility", "Radiologist"].include?(current_user.userable_type)
        transactions    = transactions.includes(:xray_facility)     if ["Radiologist"].include?(current_user.userable_type)
        @transactions   = transactions.includes(:fw_country, :doctor, :ongoing_appeals)
    end

    def transactions_index_radiologist_xray_dropdown_list

        # For radiologists only. NF-1882
        if current_user.userable_type == "Radiologist"
            x_values    = Transaction.joins(:xray_examination)
                            .select("transactions.xray_facility_id, case when transactions.xray_transmit_date is not null then 'transmitted'"\
                                "when transactions.status = 'EXAMINATION' and xray_examinations.radiologist_transmitted_at is not null then 'pending_acknowledgement'"\
                                "when transactions.status = 'EXAMINATION' and xray_examinations.radiologist_transmitted_at is null then 'examination' end exam_status")\
                            .where(xray_reporter_type: "RADIOLOGIST")
                            .search_by_user_type(current_user)
                            .search_transaction_date_start(Date.today - 1.years)
                            .group(:xray_facility_id, :exam_status).to_a

            status_facilities   = x_values.to_a.inject(Hash.new([])) {|hash, attributes| hash[attributes.exam_status] += [attributes.xray_facility_id]; hash }
            @xfacility_mapping  = XrayFacility.where(id: status_facilities.values.flatten.uniq).pluck(:code, :name, :id).sort.map {|code, name, id| [id, "#{ code } - #{ name }"] }.to_h

            @status_facility_mappings   = status_facilities.map do |id, array|
                [id, array.map {|x_id| [@xfacility_mapping[x_id], x_id] }.sort]
            end.to_h

            @status_facility_mappings.default   = @xfacility_mapping.sort.map {|array| array.reverse }
            key                 = params[:status].present? ? params[:status] : nil
            @xfacility_dropdown = @status_facility_mappings[key]
        end
    end

    def transactions_index_loading_state_list
        @states = State.order(:name).pluck(:name, :id)
    end
end