# bundle exec sidekiq -q default -q mailers

class EmployerMailer < ApplicationMailer
  def sign_up_email
    @token = params[:token]
    @url = params[:url]
    mail(to: params[:recipient], subject: "FOMEMA sign up confirmation")
  end

  def resend_sign_up_email
    @token = params[:token]
    @url = params[:url]
    mail(to: params[:recipient], subject: "Resend - FOMEMA sign up confirmation")
  end

  def pending_approval_email
    @employer = params[:employer]
    @employer_register_approval_reply_days = params[:employer_register_approval_reply_days]
    mail(to: params[:recipient], subject: "FOMEMA registration pending for approval")
  end

  def approved_email
    @activation_link = params[:activation_link]
    @employer = params[:employer]
    @name = params[:name]
    mail(to: params[:recipient], subject: "FOMEMA registration approved")
  end

  def rejected_email
    @employer = params[:employer]
    @url = params[:url]
    @reason = params[:reason]
    @name = params[:name]
    mail(to: params[:recipient], subject: "FOMEMA registration rejected")
  end


  def approved_amendment_email
    @employer = params[:employer]
    @name = params[:name]
    mail(to: params[:recipient], subject: "Employer Amendment")
  end

  def rejected_amendment_email
    @employer = params[:employer]
    @reason = params[:reason]
    @name = params[:name]
    mail(to: params[:recipient], subject: "Employer Amendment")
  end

  def incomplete_email
    @employer = params[:employer]
    @url = params[:url]
    @reason = params[:reason]
    @name = params[:name]
    mail(to: params[:recipient], subject: "FOMEMA registration incomplete")
  end

  def reset_email # Not being used anymore
    @activation_link = params[:activation_link]
    @employer = params[:employer]
    @name = params[:name]
    mail(to: params[:recipient], subject: "FOMEMA reset email approved")
  end

  def fw_amend_email
    @foreign_worker = params[:foreign_worker]
    @employer = params[:employer]
    @approval_comment = @foreign_worker.approval_items.joins('join approval_comments on approval_items.id = approval_comments.request_id').select('approval_comments.content').order("approval_comments.created_at desc").pluck('approval_comments.content').first
    approval_request = @foreign_worker.approval_items
    .joins('join approval_requests on approval_items.request_id = approval_requests.id')
    .select('approval_requests.request_user_id, approval_requests.approval_decision')
    .order("approval_requests.id desc")
    .first
    @request_user_id = approval_request&.request_user_id
    @user= User.find_by_id(@request_user_id)

    if @user!= nil && @user.role&.name == 'AGENCY'
        @agency = Agency.find(@user.userable_id)
        @customer = @agency
        mail(to: @agency.email, subject: "Foreign Worker Amendment")
    else
        @customer = @employer
        if @foreign_worker.employer_supplement_id.blank?
          mail(to: [@employer.email, @employer.user&.email, @employer.user&.unconfirmed_email].find { |email| !email.blank? }, subject: "Foreign Worker Amendment")
        else
          mail(to: @foreign_worker.employer_supplement.email, subject: "Foreign Worker Amendment")
        end
    end
  end

  def change_employer_email
    @foreign_worker = params[:foreign_worker]
    @approval_decision = params[:approval_decision]
    @approval_comment = params[:approval_comment]
    fw_change_employer = @foreign_worker.latest_fw_change_employer
    requested_by = fw_change_employer&.requested_by
    @user= User.find_by_id(requested_by)
    @employer = @foreign_worker.employer

    if @user.role&.name == 'AGENCY'
      @agency = Agency.find(@user.userable_id)
      @customer = @agency
    else
      @customer = @employer
    end

    if @user.employer_supplement_id.blank?
      mail(to: [@user.email, @user.unconfirmed_email].find { |email| !email.blank? }, subject: "Foreign Worker Amendment - Change of Employer")
    else
      mail(to: [@user.email, @user.unconfirmed_email].find { |email| !email.blank? }, cc: @employer.email, subject: "Foreign Worker Amendment - Change of Employer")
    end
  end

  def fw_transaction_reminder
    email               = params[:email]
    csv                 = params[:csv]
    @transaction_date   = params[:trans_date]
    @months_overdue     = params[:months_overdue]

    attachments["ForeignWorkers.csv"] = { mime_type: 'text/csv', content: csv }
    mail(to: email, subject: 'Foreign Workers')
  end
end