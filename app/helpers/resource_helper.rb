require 'cgi'

module ResourceHelper
    # resource form button
    def index_table_class
        "table table-bordered table-striped table-sm"
    end

    def index_table_show_button(url, label: '<i class="icon-magnifier"></i>', title: 'Detail')
        "<a class=\"btn btn-sm btn-secondary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_primary_button(url, label: '<i class="fa fa-edit"></i>', title: 'Primary', classes: "btn btn-sm btn-primary", target: "")
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\"#{" target=\"#{target}\"" if !target.blank?}>#{label}</a>"
    end

    def index_table_warning_button(url, label: '<i class="fa fa-edit"></i>', title: 'Warning', classes: "btn btn-sm btn-warning")
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_danger_button(url, label: '<i class="fa fa-edit"></i>', title: 'Danger', classes: "btn btn-sm btn-danger")
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_edit_button(url, label: '<i class="fa fa-edit"></i>', title: 'Edit', classes: 'btn btn-sm btn-primary')
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_draft_button(url, label: '<i class="fa fa-pen"></i>', title: 'Draft', classes: 'btn btn-sm btn-success')
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_cancel_button(url, label: '<i class="fa fa-times"></i>', title: 'Cancel', classes: 'btn btn-sm btn-warning')
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\" data-confirm=\"Confirm cancel?\">#{label}</a>"
    end

    def index_table_confirm_button(url, label: '<i class="fa fa-question"></i>', title: 'Confirm', classes: 'btn btn-sm btn-primary', question: 'Confirm?')
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\" data-confirm=\"#{question}\">#{label}</a>"
    end

    def index_table_approval_button(url, label: '<i class="fa fa-check text-white"></i>', title: 'Approval', classes: 'btn btn-sm btn-warning')
        "<a class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_delete_button(url, label: '<i class="fa fa-trash"></i>', title: 'Delete', classes: 'btn btn-sm btn-danger')
        "<a data-confirm=\"Are you sure?\" class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" rel=\"nofollow\" data-method=\"delete\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_bulk_submit_button(label: '<i class="fa fa-plus"></i> Bulk Action', title: 'Bulk Action', value: "bulk action", name: "bulk_action", classes: 'btn btn-sm btn-primary', form: "", formtarget: "")
        "<button name=\"#{name}\" type=\"submit\" value=\"#{value}\" class=\"#{classes}\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\"#{" formtarget=\"#{formtarget}\"" if !formtarget.blank?}#{" form=\"#{form}\"" if !form.blank?}>#{label}</button>"
    end

    def index_table_new_button(url, label: '<i class="fa fa-plus"></i> New', title: 'New')
        "<a class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_success_link(url, label: '<i class="fa fa-info"></i>', title: '')
        "<a class=\"btn btn-sm btn-success\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def show_back_button(url, label: '<i class="fa fa-history"></i> Back', title: 'Back', ignore_referer: false, extra_classes: "", btn_size: "btn-sm")
        referer_url = request.referer

        back_url =
        # Check if the referer url is the same in the current page. This defeats the purpose of a back button.
        if referer_url == request.url
            url
        elsif referer_url
            split           = url.split("?")
            base_url        = split[0]
            parameters      = split[1].present? ? split.split("&") : nil
            matching_cases  = [base_url, parameters].flatten.compact.map {|term| referer_url.include?(term)}
            # If the back_url has similar parameters or path as the referer_url, use referer_url instead.
            matching_cases.include?(false) ? url : referer_url
        else
            url
        end

        if ignore_referer
        back_url = url
        end

        "<a class=\"btn #{ btn_size } btn-secondary #{ extra_classes }\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{back_url}\">#{label}</a>"
    end

    def show_edit_button(url, label: '<i class="fa fa-edit"></i> Edit', title: 'Edit')
        "<a class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def edit_back_button(url, label: '<i class="fa fa-history"></i> Back', title: 'Back')
        "<a class=\"btn btn-sm btn-secondary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def edit_save_button(label: '<i class="icon-pencil"></i> Save', title: 'Save')
        "<button class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" type=\"submit\" name=\"submit\" value=\"Save\" data-disable-with=\"Save\">#{label}</button>"
    end

    def edit_save_continue_button(label: '<i class="icon-pencil"></i> Save and Continue', title: 'Save and Continue')
        "<button class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" type=\"submit\" name=\"submit\" value=\"Save and Continue\" data-disable-with=\"Save\">#{label}</button>"
    end

    def edit_submit_button(label: '<i class="icon-pencil"></i> Submit', title: 'Submit')
        "<button id=\"submit\" class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" type=\"submit\" name=\"submit\" value=\"Submit\" data-disable-with=\"Submit\">#{label}</button>"
    end

    def edit_save_draft_button(label: '<i class="icon-pencil"></i> Save draft', title: 'Save draft')
        "<button id= \"draft_submit\" class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" type=\"submit\" name=\"submit\" value=\"Save draft\" data-disable-with=\"Save\">#{label}</button>"
    end

    def edit_submit_for_approval_button(label: '<i class="icon-pencil"></i> Submit for approval', title: 'Submit for approval')
        "<button id= \"approval_submit\" class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" type=\"submit\" name=\"submit\" value=\"Submit for approval\" data-disable-with=\"Save\">#{label}</button>"
    end

    def approval_submit_decision_button(label: '<i class="icon-pencil"></i> Submit decision', title: 'Submit decision')
        "<button class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" type=\"submit\" name=\"submit\" value=\"Submit decision\" data-disable-with=\"Save\">#{label}</button>"
    end

    def approval_submit_concur_button(label: '<i class="icon-pencil"></i> Concur', title: 'Concur')
        "<button class=\"btn btn-sm btn-primary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" type=\"submit\" name=\"submit\" value=\"Concur\" data-disable-with=\"Save\">#{label}</button>"
    end

    def filter_back_button(url, label: '<i class="icon-action-undo"></i> Back', title: 'Back')
        "<a class=\"btn btn-sm btn-danger\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def filter_clear_button(url, label: '<i class="icon-trash"></i> Clear', title: 'Clear')
        "<a class=\"btn btn-sm btn-danger\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    # def filter_clear_button_portal(url, label: '<i class="fa fa-eraser"></i> Clear', title: 'Clear')
    #     "<a class=\"btn btn-sm btn-red-portal\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    # end

    def filter_export_excel_button(url, label: '<i class="fa fa-file-excel"></i> Export', title: 'Export', formtarget: nil)
        "<button type=\"submit\" class=\"btn btn-sm btn-warning\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" formaction=\"#{url}\" #{formtarget.blank? ? "" : " formtarget=\"#{formtarget}\" "}>#{label}</button>"
    end

    def filter_download_pdf_button(url, label: '<i class="fa fa-download"></i> Download', title: 'Download', formtarget: nil)
        "<button type=\"submit\" class=\"btn btn-sm btn-secondary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" formaction=\"#{url}\" #{formtarget.blank? ? "" : " formtarget=\"#{formtarget}\" "}>#{label}</button>"
    end

    def filter_button(label: '<i class="icon-magnifier"></i> Filter', title: 'Filter', type: "submit", name: "", value: "", formtarget: "", formaction: "")
        "<button class=\"btn btn-sm btn-primary\"
        data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\"
        #{" type=\"#{type}\"" if !type.blank?}
        #{" name=\"#{name}\"" if !name.blank?}
        #{" value=\"#{value}\"" if !value.blank?}
        #{" formtarget=\"#{formtarget}\"" if !formtarget.blank?}
        #{" formaction=\"#{formaction}\"" if !formaction.blank?}
        >#{label}</button>"
    end

    def filter_button_portal(label: '<i class="fa fa-search"></i> Search', title: 'Search', type: "submit", name: "", value: "", formtarget: "", formaction: "")
        "<button class=\"btn btn-sm btn-blue-portal\"
        data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\"
        #{" type=\"#{type}\"" if !type.blank?}
        #{" name=\"#{name}\"" if !name.blank?}
        #{" value=\"#{value}\"" if !value.blank?}
        #{" formtarget=\"#{formtarget}\"" if !formtarget.blank?}
        #{" formaction=\"#{formaction}\"" if !formaction.blank?}
        >#{label}</button>"
    end

    def index_table_approval_lvl1_button(url, label: '<i class="fa fa-check"></i>', title: 'Approval')
        "<a class=\"btn btn-sm btn-success\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end

    def index_table_approval_lvl2_button(url, label: '<i class="fa fa-check"></i>', title: 'Approval')
        "<a class=\"btn btn-sm btn-success\" data-toggle=\"tooltip\" data-html=\"true\" title=\"#{title}\" data-original-title=\"#{title}\" href=\"#{url}\">#{label}</a>"
    end
    # /resource form button

    def form_select_option_text
        "Select option"
    end

    def tag_status(status, theme: 'auto')
        if (theme == 'auto')
            case status
            when "ACTIVE", "ENABLED", "1"
                theme = "success"

            when "INACTIVE", "DISABLED", "0"
                theme = "danger"

            else
                theme = "primary"
            end
        else
            heme = "primary"
        end

        "<span class=\"badge badge-#{theme}\">#{status}</span>"
    end

    def table_dropdown_item(title, icon, path, target: nil)
        "<a class=\"dropdown-item\" href=\"#{path}\"#{" target=\"#{target}\"" if !target.nil?}><i class=\"#{icon} font-size-8\"></i>#{title}</a>"
    end

    def transaction_details_buttons(title, icon, classes, path, target: nil)
        "<a class=\"#{ classes } mb-1\" href=\"#{ path }\"#{ " target=\"#{ target }\"" if !target.nil? }><i class=\"#{ icon } mr-2\"></i>#{ title }</a>"
    end

    def truncate_comment_read_more(text)
        text.truncate(80, omission: ".replacethis.").gsub(".replacethis.", "... <span class=\"text-primary\">Read More</span>")
    end

    # for sp group schedules - empty group
    def form_no_group_text
        "No Group"
    end

    # operation hours - format date
    def format_date(date)
        date ? date.strftime('%H:%M') : ''
    end
end
