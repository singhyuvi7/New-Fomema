module BreadcrumbHelper
	def initialize_breadcrumb
		@breadcrumb_items = [
			{ title: "Home ", path: "/", active: false }
		]

		crumbs = breadcrumbs_for__restful_routes
		crumbs.map {|hash| hash[:title] = hash[:title].to_s.gsub("Xqcc", "XQCC") }
	end
private
	def breadcrumbs_for__restful_routes
		controllers_in_path.each_with_index do |this_controller_name, index|
			# Build the index matcher, that follows these rules: ^/:controller/:id/:controller/:id/:controller/ and so on. (always ends with /:controller/)
			build_matcher 		= controllers_in_path[0..index].map {|term| "\/#{ term }\/" }.join("\\d+")
			index_page_matcher 	= /^#{ build_matcher }/

			index_page_match 	= request.path.match(index_page_matcher).to_a
           
			#portal revampp change orders to payment,worker lists to register worker,
			#transaction to registration history

			index_name =
				if site == "PORTAL" && this_controller_name == "orders"
					"Payment"
				elsif site == "PORTAL" && this_controller_name == "worker_lists"
					"Register Worker"
				elsif site == "PORTAL" && this_controller_name == "transactions"
					 "Registration History"
				else
					this_controller_name.titleize
				end
          

			@breadcrumb_items 	<< { title: index_name, path: index_page_match[0], active: false } if index_page_match.count == 1

			# Build the show matcher, that follows these rules: ^/:controller/:id/:controller/:id/:controller/:id/ and so on. (always ends with /:controller/:id/)
			build_matchers		= controllers_in_path[0..index].map {|term| "\/#{ term }\/\\d+\/" }.join("").gsub("\/\/", "\/")
			show_page_matcher 	= /^#{ build_matchers }/

			show_page_matching 	= request.path.match(show_page_matcher).to_a
			@breadcrumb_items 	<< { title: show_page_titles(this_controller_name, show_page_matching[0]), path: show_page_matching[0], active: false } if show_page_matching.count == 1
		end

		case action_name
		when "index"
		
			index_page_name =
				if site == "PORTAL" && controller_name == "orders"
						"Payment"
				elsif site == "PORTAL" && controller_name == "worker_lists"
						"Register Worker"
                elsif site == "PORTAL" && controller_name == "transactions"
						"Registration History"
				else
					controller_name.titleize
				end
	    

			@breadcrumb_items << { title: index_page_name, path: request.url, active: true }
		when "new"
			@breadcrumb_items << { title: "New", path: request.url, active: true }
		when "edit"
			@breadcrumb_items << { title: "Edit", path: request.url, active: true }
		when "show"
			@breadcrumb_items << { title: show_page_titles(controller_name), path: request.url, active: true }
		else
			@breadcrumb_items << { title: action_name.titleize, path: request.url, active: true }
		end
	end

	def show_page_titles(this_controller_name, path = nil)
		# Matches the title of the show page based on the controller.
		# For example, in transactions, I would expect a @transaction instance, and from @transaction, I need code instead of ID.
		# If an error is hit, it will return Details, and near the end of the method, if an ID in integer format is found, will replace Details.

		begin
			title =
				case this_controller_name
				when "employers"
					@employer.code
				when "doctors"
					@doctor.code
				when "laboratories"
					@laboratory.code
				when "xray_facilities"
					@xray_facility.code
				when "radiologists"
					@radiologist.code
				when "employer_workers"
					@foreign_worker.code.present? ? @foreign_worker.code : @foreign_worker.name
				when "bulletins"
					@bulletin.id
				when "orders"
					@order.code
				when "bank_drafts"
					@bank_draft.id
				when "user_setups"
					@user.code
				when "roles"
					@role.id
				when "password_policies"
					@password_policy.name
				when "countries"
					@country.name
				when "states"
					@state.name
				when "towns"
					@town.name
				when "banks"
					@bank.code
				when "payment_methods"
					@payment_method.name
				when "change_sp_reasons"
					@change_sp_reason.code
				when "retake_reasons"
					@retake_reason.name
				when "block_reasons"
					@block_reason.code
				when "amendment_reasons"
					@amendment_reason.code
				when "fees"
					@fee.code
				when "employer_types"
					@employer_type.name
				when "job_types"
					@job_type.name
				when "laboratory_types"
					@laboratory_type.name
				when "titles"
					@title.name
				when "tcupi_todos"
					@tcupi_todo.id
				when "appeal_todos"
					@appeal_todo.id
				when "organizations"
					@organization.code
				when "district_health_offices"
					@district_health_office.code
				when "transactions"
					@transaction.code
				when "worker_lists"
					@foreign_worker.name
				when "appeals"
					@appeal.id
				when "agencies"
					@agency.code
				else
					"Details"
				end
		rescue
			title = "Details"
		end

		title = path.match(/#{ this_controller_name }\/\d+/).to_a[0].match(/\d+/)[0] if title == "Details" && path.present? && path.match(/#{ this_controller_name }\/\d+/)
		return title || "Details"
	end

	def controllers_in_path
		# Split the path by / and remove all the ids (assuming all ids in paths are digits).
		request.path.split("/").select {|term| term.match(/(?!\d+)\w+/).to_a.present? }
	end
end