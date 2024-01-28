# Preview all emails at http://localhost:3000/rails/mailers/refund_mailer
class RefundMailerPreview < ActionMailer::Preview
	def a__manual_refund_created_email
		r 	= Refund.last
		RefundMailer.with({refund: r}).manual_refund_created_email
	end

	def b__manual_refund_reject_email
		r 	= Refund.last
		RefundMailer.with({refund: r}).manual_refund_reject_email
	end

	def c__auto_refund_email
		r 	= Refund.last
		RefundMailer.with({customerable: r.customerable}).auto_refund_email
	end

	def d__failed_email
		r 	= Refund.last
		RefundMailer.with({refund: r}).failed_email
	end

	def e__auto_refund_fail_email
		r 	= Refund.last
		RefundMailer.with({customerable: r.customerable}).auto_refund_fail_email
	end
end
