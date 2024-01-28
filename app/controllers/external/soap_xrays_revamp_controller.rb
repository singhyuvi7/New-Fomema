class External::SoapXraysRevampController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:process_request]

	def get_xml
		render :xml => nil, layout: false, content_type: "text/xml"
	end
end