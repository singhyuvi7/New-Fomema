class InspectorateMailer < ApplicationMailer    
    def visit_report
      attachments['visit_report.pdf'] = params[:file]
      mail(to: params[:recipient], subject: "Visit Report")
    end
end
  