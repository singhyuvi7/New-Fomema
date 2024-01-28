# Preview all emails at http://localhost:3000/rails/mailers/employer_mailer
class EmployerMailerPreview < ActionMailer::Preview
  def a__sign_up_email
    EmployerMailer.with({
    	recipient: "sample@sample.com", 
    	token: "SampleToken123", 
    	url: "<URL>"
    }).sign_up_email
  end

  def b__resend_sign_up_email
    EmployerMailer.with({
        recipient: "sample@sample.com",
        token: "SampleToken123",
        url: "<URL>"
    }).resend_sign_up_email
  end

  def c__pending_approval_email
    EmployerMailer.with({
        recipient: "sample@sample.com",
        employer: Employer.last,
        employer_register_approval_reply_days: "X"
    }).pending_approval_email
  end

  def d__approved_email
    EmployerMailer.with({
        recipient: "sample@sample.com",
        activation_link: "<URL>",
        name: Employer.last.name
    }).approved_email
  end 
  
  def e__rejected_email
    EmployerMailer.with({
        recipient: "sample@sample.com",
        name: "XXXX",
        reason: "<Reason>",
        url: "<URL>"
    }).rejected_email
  end

  def f__fw_amend_email
    EmployerMailer.with({
        foreign_worker: ForeignWorker.last,
        employer: ForeignWorker.last.employer
    }).fw_amend_email
  end

end
