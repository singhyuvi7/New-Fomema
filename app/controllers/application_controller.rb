require "current"

class ApplicationController < ActionController::Base
    include ApplicationHelper
    include AuthorizeCheck
    layout "application"
    # before_action :debugall
    add_flash_types :error, :errors, :warning, :warnings, :notices, :info, :infos

    before_action :set_raven_sentry_user,           except: :on_development?
    before_action :configure_permitted_parameters,  if: :devise_controller?
    before_action :check_browser_ie,                if: :get_request?
    before_action :set_user_permissions
    before_action :set_company_name

    helper_method :has_permission?, :has_any_permission?, :site, :current_user, :get_per, :get_per_options, :vd, :per_link, :can_request_update?, :can_continue_draft?, :can_do_approval?, :can_do_approval2?, :can_cancel_approval?, :seq_nextval, :seq_currval, :on_development?, :on_staging?, :on_production?, :on_stagingali?, :on_nios?, :on_merts?, :on_portal?, :get_standard_date_format, :get_standard_datetime_format, :get_standard_time_format

    def has_permission?(permission)
        @all_permissions.include?(permission.upcase)
    end

    def has_any_permission?(*permissions)
        permissions.each do |p|
            if @all_permissions.include?(p.upcase)
                return true
            end
        end
        return false
    end

    def set_user_permissions
        if !@all_permissions && defined?(current_user) && current_user
            user_permissions = UserPermission.where(user_id: current_user.id).pluck(:permission)
            role_permissions = RolePermission.where(role_id: current_user.role_id).pluck(:permission)
            @all_permissions = user_permissions + role_permissions
        end
    end

    def check_password_expiry
        if current_user.role.password_policy.password_expiry > 0 && current_user.password_changed_at < DateTime.now.months_ago(current_user.role.password_policy.password_expiry)
            redirect_to password_path and return
        end
    end

    def site
        if request.subdomain == ENV["SUBDOMAIN_NIOS"].downcase
            "NIOS"
        elsif request.subdomain == ENV["SUBDOMAIN_MERTS"].downcase
            "MERTS"
        elsif request.subdomain == ENV["SUBDOMAIN_PORTAL"].downcase
            "PORTAL"
        else
            nil
        end
    end

    def get_per
        if params.include? :per
            params[:per].to_i
        else
            10
        end
    end

    def get_per_options
        [10, 20, 30, 50, 100, 200, 500, 1000, 2000]
    end

    def get_standard_date_format
        "%d/%m/%Y"
    end

    def get_standard_datetime_format
        "%d/%m/%Y %l:%M:%S %p"
    end

    def get_standard_time_format
        "%l:%M:%S %p"
    end

    def get_ip_address
        request.headers["X-Forwarded-For"] || request.remote_ip
    end

    # def document_types
    #     ['Passport', 'IC Number']
    # end

    def seq_nextval(seq_name)
        ActiveRecord::Base.connection.execute("SELECT nextval('#{seq_name}')")[0]["nextval"]
    end

    def seq_currval(seq_name)
        ActiveRecord::Base.connection.execute("SELECT currval('#{seq_name}')")[0]["currval"]
    end

    def vd(*p2)
        require 'pp'
        puts "=============== vd start ==============="
        p2.each.with_index do |p, index|
            puts "" if index > 0
            puts p.class
            pp p
        end
        puts "=============== vd end   ==============="
    end

    def vdr(p)
        p.pretty_inspect
    end

    def per_link(per_item)
        uri = URI::parse(request.original_url)
        if !uri.query.nil?
            cgi = CGI.parse(uri.query)
            cgi.each do |k, v|
                cgi[k] = v.first
            end
        else
            cgi = {}
        end
        cgi["per"] = per_item
        uri.query = cgi.to_query
        uri.to_s
    end

    def configure_permitted_parameters
        added_attrs = [:login, :login_type, :login_from, :password, :remember_me, :login_user_type]
        devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    end

    def on_development?
        Rails.env.development?
    end

    def on_staging?
        Rails.env.staging? ||
            Rails.env.stagingali? ||
            Rails.env.stagingali2?
    end

    def on_production?
        Rails.env.production? ||
            Rails.env.production1? ||
            Rails.env.production2? ||
            Rails.env.production3?
    end

    def on_nios?
        request.subdomain == ENV["SUBDOMAIN_NIOS"].downcase
    end

    def on_merts?
        request.subdomain == ENV["SUBDOMAIN_MERTS"].downcase
    end

    def on_portal?
        request.subdomain == ENV["SUBDOMAIN_PORTAL"].downcase
    end

    def check_browser_ie
        browser     = Browser.new(request.env['HTTP_USER_AGENT'])
        @is_ie  = browser.ie?
    end

    def set_company_name
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value.try(:upcase)
    end
private
    def set_raven_sentry_user
        if current_external_user
            Raven.user_context(id: current_external_user.id, email: current_external_user.email)
        elsif current_internal_user
            Raven.user_context(id: current_internal_user.id, email: current_internal_user.email)
        end

        Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
end