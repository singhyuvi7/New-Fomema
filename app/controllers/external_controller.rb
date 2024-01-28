class ExternalController < ApplicationController
    layout "external"
    before_action :authenticate_external_user!
    before_action :current_user,              if: :external_user_signed_in?
    before_action :check_password_expiry,     if: :external_user_signed_in?
    before_action :displayed_avatar_name,     if: :external_user_signed_in?
    before_action :pending_xray_retakes,      if: :external_user_signed_in?
    before_action :pending_notifiable_cases,  if: :external_user_signed_in?

    around_action :set_current_user

    def current_user
        current_external_user
    end

    def set_current_user
        Current.user = current_user
        yield
    ensure
        # to address the thread variable leak issues in Puma/Thin webserver
        Current.user = nil
    end

    def password_path
        external_password_path
    end

    def displayed_avatar_name
        userable = current_user.userable

        @displayed_avatar_name = case userable.class.name
        when "Doctor"
            "#{ userable.name }, #{ userable.clinic_name } (#{ userable.code })"
        when "Laboratory"
            "#{ userable.name } (#{ userable.code })"
        when "XrayFacility"
            "#{ userable.name } (#{ userable.code })"
        when "Radiologist"
            "#{ userable.name } (#{ userable.code })"
        when "Employer"
            # "#{ userable.name } (#{ userable.code })"
            current_user.employer_supplement_id.blank? ? "#{ userable.name } (#{ userable.code })" : "#{ userable.name } (#{ userable.code }) | #{ current_user.username}"
        when "Agency"
            "#{ userable.name } (#{ userable.code })"
        end
    end

    def pending_xray_retakes
        if has_any_permission?("VIEW_ALL_TRANSACTION", "VIEW_BRANCH_TRANSACTION", "VIEW_OWN_TRANSACTION")
            if ["XrayFacility"].include?(current_user.userable_type)
                @navbar_pending_retakes = XrayRetake.where(status: ["APPROVED", "IN_PROGRESS"], xray_facility_id: current_user.userable_id).count > 0
            elsif ["Radiologist"].include?(current_user.userable_type)
                @navbar_pending_retakes = XrayRetake.where(status: ["APPROVED", "IN_PROGRESS"], radiologist_id: current_user.userable_id).count > 0
            end
        end
    end

    def pending_notifiable_cases
        if ["Doctor", "XrayFacility"].include?(current_user.userable_type)
            @navbar_notifiable_cases = AmendedNotifiableTransaction.where(notifiable_type: current_user.userable_type, notifiable_id: current_user.userable_id, notify_pkd_at: nil).count > 0
        end
    end

end
