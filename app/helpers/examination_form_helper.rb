module ExaminationFormHelper
	def boolean_field_button(active_color: "danger", active: true, readonly: false, value: "YES", placeholder: "YES", classes: "", name: "")
		"<div class=\"btn btn-#{ active ? active_color : "default" } #{ readonly ? "boolean-field-btn-dummy" : "toggle-boolean-field-btn" } font-weight-bold w-em-8 #{classes}\" data-active=\"btn-#{active_color}\" data-type=\"#{ value }\" #{ "data-name=\"#{name}\"" if name.present? }>#{ placeholder }</div>"
	end

	def secondary_field_button(value: "", placeholder: "", classes: "", name: "")
		"<div class=\"btn btn-secondary font-weight-bold w-em-8 #{classes}\" data-type=\"#{ value }\" #{ "data-name=\"#{name}\"" if name.present? }>#{ placeholder }</div>"
	end

	def generate_field_id(form, field_name)
		"#{ form.object_name.gsub("[", "_").delete("]") }_#{ field_name }"
	end

	def setting_column_sizes(column_size, column_count, last_column)
		# Only supports column sizes of 6 or 12.
		column_count ||= 0
		column_size = [6, 12].include?(column_size) ? column_size : 6

        opening_row =
            if column_count == 0
                '<div class="row">'
            elsif column_size == 12
                '</div><div class="row">'
            end

        if column_size == 6
            subcolumn_1 = 4
            subcolumn_2 = 8
        elsif column_size == 12
            subcolumn_1 = 2
            subcolumn_2 = 10
        end

        column_count += column_size

        closing_row =
            if column_count >= 12 || last_column
                column_count = 0
                "</div>"
            end

        return column_size, column_count, opening_row, closing_row, subcolumn_1, subcolumn_2
    end

    def transaction_displayed_sections
        @displayed_sections = []
        @displayed_sections << "Medical History"            if has_permission?("VIEW_DOCTOR_DATA_TRANSACTION")
        @displayed_sections << "Physical Examination"       if has_permission?("VIEW_DOCTOR_DATA_TRANSACTION")
        @displayed_sections << "System Exam"                if has_permission?("VIEW_DOCTOR_DATA_TRANSACTION")
        @displayed_sections << "Laboratory"                 if has_permission?("VIEW_LABORATORY_DATA_TRANSACTION") && @transaction.laboratory_examination.try(:transmitted_at?)
        @displayed_sections << "X-Ray"                      if has_permission?("VIEW_XRAY_DATA_TRANSACTION") && @transaction.xray_examination.try(:transmitted_at?)
        @displayed_sections << "Certification"              if has_permission?("VIEW_CERTIFICATION_DATA_TRANSACTION") && ["CERTIFICATION", "REVIEW", "CERTIFIED"].include?(@transaction.status)
        @displayed_sections << "Pending Reviews"            if has_any_permission?("VIEW_PENDING_REVIEW_AND_TCUPI_DATA_TRANSACTION", "VIEW_PENDING_REVIEWS") && @medical_review.present?
        @displayed_sections << "TCUPI Reviews"              if has_any_permission?("VIEW_PENDING_REVIEW_AND_TCUPI_DATA_TRANSACTION", "VIEW_TCUPI_REVIEWS", "VIEW_TCUPI_APPROVALS") && @tcupi_review.present?

        # In transactions__show (nios), you can see this at the bottom.
        unless controller_action_name == "transactions__show"
            @displayed_sections << "Update Result"              if has_permission?("VIEW_AMENDMENT_UPDATE_RESULT_DATA_TRANSACTION") && @result_updates.present?
            @displayed_sections << "Amendment Final Result"     if has_permission?("VIEW_AMENDMENT_FINAL_RESULT_DATA_TRANSACTION") && @amendments.present?
        end

        # Only for Doctor, Branch can view this in Transactions#Show
        if current_user.userable_type == "Doctor"
            @displayed_sections << "Xray Pending Review"    if has_permission?("VIEW_XQCC_DATA_TRANSACTION") && @xray_pending_decisions.present?
        else
            # XQCC/PCR Related.
            @displayed_sections << "XQCC"                   if has_permission?("VIEW_XQCC_DATA_TRANSACTION") && @pcr_comments.present?
            @displayed_sections << "Pending Decision"       if has_permission?("VIEW_XQCC_DATA_TRANSACTION") && @xray_pending_decisions.present?

            # NF-1722 - show only transaction's related, no need previous blah blah blah
            # @displayed_sections << "MLE Comments"           if has_permission?("VIEW_XQCC_PENDING_REVIEW") && @previous_xqcc_pd.present?

            # NF-1835 - Display transaction_comments & xqcc_transaction_comments from migrated data.
            @displayed_sections << "MLE Comments"           if has_permission?("VIEW_XQCC_PENDING_REVIEW") && (@display_t_comments.present? || @display_xt_comments.present?)

            @displayed_sections << "XQCC"                   if (@displayed_sections & ["Pending Decision", "MLE Comments"]).present?
        end

        # Will display if any of the 3 is present.
        @displayed_sections << "FOMEMA Result Review"       if (@displayed_sections & ["Pending Reviews", "TCUPI Reviews", "Xray Pending Review"]).present?

        # Appeals
        @displayed_sections << "Appeal"                     if has_any_permission?("VIEW_APPEAL_DATA_TRANSACTION", "VIEW_APPEALS") && (@appeals.present? || @appeal.present?)

        # Only to display in Branch side, and must have permissions. Also, only visible on certain pages.
        @displayed_sections << "Unsuitable Reasons"         if has_permission?("VIEW_UNSUITABLE_REASONS_DATA_TRANSACTIONS") && on_nios? && ["REVIEW", "CERTIFIED"].include?(@transaction.status) && controller_action_name == "transactions__show"
    end
end