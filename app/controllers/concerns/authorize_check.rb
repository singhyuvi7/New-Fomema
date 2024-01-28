module AuthorizeCheck
    # Please only use can_access? for permissions. The other methods below are very specific to Fathur's PCR/XQCC flow/models.

    def can_access?(*permissions, redirect_to: nil, error: nil, warning: nil, notice: nil)
        if !has_any_permission?(*permissions)
            messages = []
            if !error.blank?
                flash[:error] = error
                messages << error
            end
            if !warning.blank?
                flash[:warning] = warning
                messages << warning
            end
            if !notice.blank?
                flash[:notice] = notice
                messages << notice
            end
            if redirect_to.blank?
                redirect_to = request.env["HTTP_REFERER"] || internal_root_path
            end

            if messages.count == 0
                flash[:error] = "It appears that you don't have permission to access this page. Please make sure you're authorized to view this content."
            end

            redirect_to redirect_to and return
        end
    end

    def can_view?(model, permissions)
        raise "Unauthorized" unless model.is_owner?(current_user.id)
        raise "Unauthorized" unless has_any_permission?(permissions)
    end

    # Please take note, can_edit? is a method that is manually defined in the model. If your model does not have it, it will throw an error.
    def can_update?(model, permissions)
        raise "Unauthorized" unless model.is_owner?(current_user.id)
        raise "Unauthorized" unless model.can_edit?
        raise "Unauthorized" unless has_any_permission?(permissions)
    end

    def can_view_approval?(permissions)
        raise "Unauthorized" unless has_any_permission?(permissions)
    end

    # Please take note, can_edit_approval? is a method that is manually defined in the model. If your model does not have it, it will throw an error.
    def can_update_approval?(model, permissions)
        raise "Unauthorized" if model.is_owner?(current_user.id)
        raise "Unauthorized" unless model.can_edit_approval?
        raise "Unauthorized" unless has_any_permission?(permissions)
    end
end