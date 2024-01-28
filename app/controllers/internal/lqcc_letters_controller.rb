class Internal::LqccLettersController < InternalController

    before_action -> { can_access?("VIEW_LQCC_LETTER") }, only: [:index, :show, :explanation_letter, :warning_letter]
    before_action -> { can_access?("CREATE_LQCC_LETTER") }, only: [:new, :create]
    before_action -> { can_access?("EDIT_LQCC_LETTER") }, only: [:edit, :update]
    before_action -> { can_access?("APPROVAL_LQCC_LETTER") }, only: [:approval, :approval_update]
    before_action -> { can_access?("DELETE_LQCC_LETTER") }, only: [:destroy]

    before_action :set_letter, only: [:show, :edit, :update, :destroy, :approval, :approval_update, :explanation_letter, :edit_warning_letter, :update_warning_letter, :approval_warning_letter, :update_approval_warning_letter, :warning_letter, :preview_explanation_letter, :preview_warning_letter]
    before_action :set_visit_report, only: [:show, :new, :edit, :update, :destroy, :approval, :explanation_letter, :edit_warning_letter, :update_warning_letter, :approval_warning_letter, :update_approval_warning_letter, :warning_letter, :preview_explanation_letter, :preview_warning_letter]
    before_action :set_signee_info, only: [:preview_explanation_letter, :warning_letter, :explanation_letter, :preview_warning_letter]

    def index
        @letters = LqccLetter.search_visit_report_code(params[:visit_report_code])
        .search_laboratory_code(params[:laboratory_code])
        .order('lqcc_letters.created_at DESC')
        .page(params[:page])
        .per(get_per)
    end

    def new
        @letter = LqccLetter.new({
            explanation_type: params[:letter_type],
            visit_report_id: params[:visit_report_id],
            explanation_status: 'DRAFT'
        })
    end

    def create
        visit_report = VisitReport.find(params[:lqcc_letter][:visit_report_id])

        if visit_report.blank?
            ## show error page since visit report doesnt exist
        end

        letter_data = lqcc_letter_params
        letter_data[:explanation_status] = 'DRAFT'
        submit_action = params[:submit_action]
        letter_data[:laboratory_pic_name] = @visit_report&.visit_report_laboratory_summary&.lab_personnel_name
        # VisitReport.find(params[:lqcc_letter][:visit_report_id]).visitable&.pic_name

        if submit_action != 'submit_with_signature'
            letter_data = letter_data.except(:explanation_signature_name, :explanation_signature_designation, :explanation_signature)
        end

        @letter = LqccLetter.new(letter_data)

        case params[:submit]
        when "Save draft"
            @letter.assign_attributes({
                explanation_status: "DRAFT"
            })
            flash[:notice] = "Explanation letter was successfully created as draft."
        when "Submit for approval"
            @letter.assign_attributes({
                explanation_status: "APPROVAL",
                explanation_request_by: current_user.id,
                explanation_request_at: Time.now
            })
            flash[:notice] = "Explanation letter was successfully created, pending for approval."
        else
            flash[:notice] = "Explanation letter was successfully created as draft."
        end

        respond_to do |format|
            if @letter.save
                if (submit_action != 'submit_with_signature') && params[:submit] != "Save draft"
                    redirect_path = internal_lqcc_letters_path
                else
                    redirect_path = edit_internal_lqcc_letter_path(@letter)
                end

                format.html { redirect_to redirect_path }
                format.json { render :show, status: :created, location: @letter }
            else
                format.html { render :new }
                format.json { render json: @letter.errors, status: :unprocessable_entity }
            end
        end
    end

    def show
    end

    def edit
    end

    def update
        letter_data = lqcc_letter_params
        submit_action = params[:submit_action]

        if (submit_action != 'submit_with_signature') && params[:submit] != "Save draft"
            letter_data = letter_data.except(:explanation_signature_name, :explanation_signature_designation, :explanation_signature)
            redirect_path = internal_lqcc_letters_path
        else
            redirect_path = edit_internal_lqcc_letter_path(@letter)
        end

        @letter.assign_attributes(letter_data)

        case params[:submit]
        when "Save draft"
            @letter.assign_attributes({
                explanation_status: "DRAFT"
            })
            flash[:notice] = "Explanation letter was successfully updated."
        when "Submit for approval"
            @letter.assign_attributes({
                explanation_status: "APPROVAL",
                explanation_request_by: current_user.id,
                explanation_request_at: Time.now
            })
            flash[:notice] = "Explanation letter was successfully submit for approval."
        else
            flash[:notice] = "Explanation letter was successfully updated."
        end

        respond_to do |format|
            if @letter.save
                format.html { redirect_to redirect_path }
                format.json { render :show, status: :ok, location: @letter }
            else
                format.html { render :edit }
                format.json { render json: @letter.errors, status: :unprocessable_entity }
            end
        end
    end

    def approval
    end

    def approval_update
        @letter.assign_attributes({
            explanation_approval_decision: approval_params[:decision],
            explanation_approval_comment: approval_params[:comment],
            explanation_approval_by: current_user.id,
            explanation_approval_at: Time.now
        })

        case approval_params[:decision]
        when "APPROVE"
            @letter.update({
                explanation_status: "APPROVED"
            })
            flash[:notice] = "Request approved"
        when "REJECT"
            @letter.update({
                explanation_status: "REJECTED"
            })
            flash[:notice] = "Request rejected"
        end

        redirect_to internal_lqcc_letters_path
    end

    def destroy
        @letter.destroy
        respond_to do |format|
            format.html { redirect_to internal_lqcc_letters_path, notice: "Letter for visit report code #{@visit_report.code} was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    def preview_explanation_letter
        @is_preview = true
        file = "pdf_templates/lqcc/explanation_letter_#{@letter.explanation_type.downcase}"
        # render file, layout: 'pdf' and return
        render pdf: "explanation_letter",
        template: file,
        layout: "pdf.html",
        margin: {
            top: 33,
            left: 25,
            right: 25,
            bottom: 20,
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        header: {
            html: {
                template: 'pdf_templates/lqcc/header'
            }
        } and return
    end

    def explanation_letter
        @letter.explanation_letter_date = DateTime.now
        @letter.save!
  
        # debug mode on / off
        @debug = false

        file = "pdf_templates/lqcc/explanation_letter_#{@letter.explanation_type.downcase}"
  
        # enable debug by passing ?debug param in url
        if params.has_key?(:debug)
            @debug = true
            render file, layout: 'pdf'
        else
            render pdf: "explanation_letter",
            template: file,
            layout: "pdf.html",
            margin: {
                top: 33,
                left: 25,
                right: 25,
                bottom: 20,
            },
            page_size: nil,
            page_height: "29.7cm",
            page_width: "21cm",
            dpi: "300",
            header: {
                html: {
                    template: 'pdf_templates/lqcc/header'
                }
            }
        end
    end

    ## warning letter
    def edit_warning_letter
        render 'internal/lqcc_letters/warning_letter/edit' and return
    end

    def update_warning_letter
        letter_data = lqcc_letter_params
        submit_action = params[:submit_action]

        if submit_action != 'submit_with_signature' && params[:submit] != "Save draft"
            letter_data = letter_data.except(:warning_signature_name, :warning_signature_designation, :warning_signature)
            redirect_path = internal_lqcc_letters_path
        else
            redirect_path = edit_warning_letter_internal_lqcc_letter_path(@letter)
        end

        @letter.assign_attributes(letter_data)

        case params[:submit]
        when "Save draft"
            @letter.assign_attributes({
                warning_status: "DRAFT"
            })
            flash[:notice] = "Warning letter was successfully updated."
        when "Submit for approval"
            @letter.assign_attributes({
                warning_status: "APPROVAL",
                warning_request_by: current_user.id,
                warning_request_at: Time.now
            })
            flash[:notice] = "Warning letter was successfully submit for approval."
        else
            flash[:notice] = "Warning letter was successfully updated."
        end

        respond_to do |format|
            if @letter.save
                format.html { redirect_to redirect_path }
                format.json { render :show, status: :ok, location: @letter }
            else
                format.html { render :edit }
                format.json { render json: @letter.errors, status: :unprocessable_entity }
            end
        end
    end

    def approval_warning_letter
        render 'internal/lqcc_letters/warning_letter/approval' and return
    end

    def update_approval_warning_letter
        @letter.assign_attributes({
            warning_approval_decision: approval_params[:decision],
            warning_approval_comment: approval_params[:comment],
            warning_approval_by: current_user.id,
            warning_approval_at: Time.now
        })

        case approval_params[:decision]
        when "APPROVE"
            @letter.update({
                warning_status: "APPROVED"
            })
            flash[:notice] = "Request approved"
        when "REJECT"
            @letter.update({
                warning_status: "REJECTED"
            })
            flash[:notice] = "Request rejected"
        end

        redirect_to internal_lqcc_letters_path
    end

    def warning_letter
        @letter.warning_letter_date = DateTime.now
        @letter.save!

        # debug mode on / off
        @debug = false
        file = 'pdf_templates/lqcc/warning_letter'
  
        # enable debug by passing ?debug param in url
        if params.has_key?(:debug)
            @debug = true
            render file, layout: 'pdf'
        else
            render pdf: "warning_letter",
            template: file,
            layout: "pdf.html",
            margin: {
                top: 33,
                left: 25,
                right: 25,
                bottom: 20,
            },
            page_size: nil,
            page_height: "29.7cm",
            page_width: "21cm",
            dpi: "300",
            header: {
                html: {
                    template: 'pdf_templates/lqcc/header'
                }
            }
        end
    end

    def preview_warning_letter
        @is_preview = true
        file = 'pdf_templates/lqcc/warning_letter'
  
        # enable debug by passing ?debug param in url
        if params.has_key?(:debug)
            @debug = true
            render file, layout: 'pdf'
        else
            render pdf: "warning_letter",
            template: file,
            layout: "pdf.html",
            margin: {
                top: 33,
                left: 25,
                right: 25,
                bottom: 20,
            },
            page_size: nil,
            page_height: "29.7cm",
            page_width: "21cm",
            dpi: "300",
            header: {
                html: {
                    template: 'pdf_templates/lqcc/header'
                }
            }
        end
    end

private
    def set_visit_report
        visit_report_id = params[:visit_report_id].blank? ? @letter.visit_report_id : params[:visit_report_id]
        @visit_report = VisitReport.find(visit_report_id)
    end

    def set_letter
        @letter = LqccLetter.find(params[:id])
    end

    def setExplanationLetterStatus(letter_data, submit_action)
        if submit_action == 'submit'
            letter_data[:explanation_status] = 'LEVEL_1_APPROVAL'
        else
            letter_data[:explanation_status] = 'DRAFT'
        end

        return letter_data
    end

    def lqcc_letter_params
        params.require(:lqcc_letter).permit(:visit_report_id, :explanation_type, :visit_time, :reply_date, :explanation_status, :explanation_signature_name, :explanation_signature_designation, :explanation_signature, :warning_signature_name, :warning_signature_designation, :warning_signature, :explanation_letter_date, :explanation_non_compliances, :explanation_clauses, :warning_clauses, :laboratory_pic_name, :operation_type)
    end

    def approval_params
        params.require(:approval).permit(:decision, :comment)
    end

    def set_signee_info
        @signee_name = TemplateVariable.find_by_code('LQCC_LETTER_SIGNEE_NAME')&.value
        @signee_position = TemplateVariable.find_by_code('LQCC_LETTER_SIGNEE_POSITION')&.value
    end
end
