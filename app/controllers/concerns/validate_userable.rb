module ValidateUserable

    def validate_user_email?(userable,new_email)

        class_name = userable.class.name
        userable_id = userable.id
        if class_name == 'User'
            class_name = userable.userable_type
            userable_id = userable.userable_id
            new_email = params[class_name.constantize.table_name.singularize][:email]
        end

        user                 = User.where(:userable_type => class_name ,:userable_id => userable_id).first
        model                = class_name.constantize
        user_not_in_sp_group = if user.present?
            !ServiceProviderGroup::CATEGORIES.map(&:first).concat(["Radiologist"]).include?(user.userable_type)
        else
            false
        end

        if user_not_in_sp_group
            if user.blank?
                user = model.find(userable.id)
                if !user.blank?
                    if model.where('email ilike ?', new_email.gsub('_', '\\_')).where.not(id: user.try(:id)).where.not(status: "INACTIVE").first.present?
                        flash[:error] = "Email #{new_email} already exists"
                        redirect_to request.referrer and return 
                    end
                end
            else
                if !new_email.blank? && User.where("email ilike ?", new_email.gsub('_', '\\_')).where.not(id: user.try(:id)).where(userable_type: user.userable_type).where.not(status: "INACTIVE").first.present?
                    flash[:error] = "Email #{new_email} already exists. Please enter another email address."
                    redirect_to request.referrer and return 
                end
            end
        end
    end

    def validate_setup_user_email?(user, new_email)
        user_not_in_sp_group            = !ServiceProviderGroup::CATEGORIES.map(&:first).concat(["Radiologist"]).include?(user.userable_type)

        if user_not_in_sp_group
            if User.where("email ilike ?", new_email.gsub('_', '\\_')).where.not(id: user.try(:id)).where(userable_type: user.userable_type).where.not(status: "INACTIVE").first.present?
                flash[:error] = "Email #{new_email} already exists"
                redirect_to request.referrer and return 
            end
        end
    end

    def validate_email_with_plus_sign(email)
        if SystemConfiguration.get("BLOCK_EMAIL_WITH_PLUS_SIGN") == "1" && email.include?('+')
            flash[:error] = "Email #{email} contains plus (+) character is not allowed."
            redirect_to request.referrer and return 
        end
    end

end