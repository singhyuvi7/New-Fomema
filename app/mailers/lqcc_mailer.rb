class LqccMailer < ApplicationMailer    
    def visit_summary
      attachments['summary.pdf'] = params[:file]
      mail(to: params[:recipient], subject: "LQCC Visit Summary")
    end
end
  