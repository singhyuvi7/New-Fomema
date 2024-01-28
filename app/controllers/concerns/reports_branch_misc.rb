module ReportsBranchMisc
    def employer_registration_by_state
        worksheet = [data: ["Employer registration request report"], style: styling(bold)]

        worksheet << {
            data: ["State", "Approve", "Reject", "Total"],
            style: styling(bold, border) + styling(bold, border(:t, :b)) * 2 + styling(bold, border)
        }

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"
            all_totals  = []

            employers   = ActiveRecord::Base.connection.execute("select states.name,
                sum(case when emp.status = 'ACTIVE' then 1 else 0 end) approved,
                sum(case when emp.status = 'REJECTED' then 1 else 0 end) rejected,
                sum(case when emp.status = 'ACTIVE' or emp.status = 'REJECTED' then 1 else 0 end) total
                from employers emp join states on states.id = emp.state_id
                where emp.created_at > '#{ start_date }' and emp.created_at < '#{ end_date }'
                group by states.name order by states.name")
        end

        if employers.to_a.present?
            employers.each do |row|
                all_totals << row.values[1..-1]

                worksheet << {
                    data: row.values,
                    style: styling(border(:l, :r)) + [{}] * 2 + styling(border(:l, :r))
                }
            end

            final_totals = all_totals.present? ? all_totals.transpose.map(&:sum) : [0] * 3

            worksheet << {
                data: ["Total"] + final_totals,
                style: styling(border) + styling(border(:t, :b)) * 2 + styling(border)
            }
        end

        @extended_headers   = 2
        @column_widths      = []
        @column_widths      << [22] + [16] * 3
        @filter_options     = [{ type: "date range", label: "Registration Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("employer_registration_by_state#{ timestamp }")
    end

    def total_change_clinic
        worksheet = [data: ["Total change Clinic"], style: styling(bold)]

        worksheet << {
            data: ["Branch", "Charge", "FOC", "Total"],
            style: styling(bold, border) + styling(bold, border(:t, :b)) * 2 + styling(bold, border)
        }

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"
            all_totals  = []

            orders   = ActiveRecord::Base.connection.execute("select org.name,
                sum(case when pm.code != 'FOC' then 1 else 0 end) charge,
                sum(case when pm.code = 'FOC' then 1 else 0 end) foc
                from orders
                left join payment_methods pm on pm.id = orders.payment_method_id
                left join organizations org on org.id = orders.organization_id
                where orders.status = 'PAID' and orders.category = 'TRANSACTION_CHANGE_DOCTOR'
                and paid_at >= '#{ start_date }' and paid_at < '#{ end_date }'
                group by org.name
                union all
                select org.name,
                sum(case when ea.amount != 0 then 1 else 0 end) charge,
                sum(case when ea.amount = 0 then 1 else 0 end) foc
                from fomema_backup_nios.employer_account ea left join organizations org on org.code = ea.branch_code
                where ea.type = 12 and ea.creation_date >= '#{ start_date }' and ea.creation_date < '#{ end_date }'
                group by org.name
            ")
        end

        if orders.to_a.present?
            all_names   = orders.map {|hash| hash["name"] }.uniq.sort

            all_names.each do |name|
                rows        = orders.select {|hash| hash["name"] == name }
                values      = rows.map {|hash| [hash.values[1..-1], hash.values[1..-1].sum].flatten }
                row_values  = values.transpose.map(&:sum)
                all_totals  << row_values

                worksheet   << {
                    data: [name] + row_values,
                    style: styling(border(:l, :r)) + [{}] * 2 + styling(border(:l, :r))
                }
            end

            final_totals = all_totals.present? ? all_totals.transpose.map(&:sum) : [0] * 3

            worksheet << {
                data: ["Total"] + final_totals,
                style: styling(border) + styling(border(:t, :b)) * 2 + styling(border)
            }
        end

        @extended_headers   = 2
        @column_widths      = []
        @column_widths      << [22] + [16] * 3
        @filter_options     = [{ type: "date range", label: "Change Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("total_change_clinic#{ timestamp }")
    end

    def total_amendment_cases
        worksheet           = [data: ["Branch Amendment Report"], style: styling(bold, align(:h))]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"

            nios_side   = ActiveRecord::Base.connection.execute("select org.name branch_name,
                sum(case when ar.code = 'AUTHORITY_REQUEST' then 1 else 0 end) authority,
                sum(case when ar.code = 'CHANGE_NEW_PASSPORT' then 1 else 0 end) new_passport,
                sum(case when ar.code = 'JOB_TYPE' then 1 else 0 end) job_type,
                sum(case when ar.code = 'DOB' then 1 else 0 end) dob,
                sum(case when ar.code = 'PASSPORT' then 1 else 0 end) passport,
                sum(case when ar.code = 'COUNTRY' then 1 else 0 end) country,
                sum(case when ar.code = 'NAME' then 1 else 0 end) as name
                /*sum(case when ar.code not in ('AUTHORITY_REQUEST', 'CHANGE_NEW_PASSPORT', 'JOB_TYPE', 'DOB', 'PASSPORT', 'COUNTRY', 'NAME') then 1 else 0 end) other,
                count(*) total */
                from foreign_worker_amendment_reasons fwar join amendment_reasons ar on ar.id = fwar.amendment_reason_id
                join users on users.id = fwar.created_by
                join organizations org on org.id = users.userable_id and users.userable_type = 'Organization'
                where fwar.created_at >= '#{ start_date }' and fwar.created_at < '#{ end_date }'
                group by branch_name order by branch_name")

            portal_side = ActiveRecord::Base.connection.execute("select states.name state_name,
                sum(case when ar.code = 'AUTHORITY_REQUEST' then 1 else 0 end) authority,
                sum(case when ar.code = 'CHANGE_NEW_PASSPORT' then 1 else 0 end) new_passport,
                sum(case when ar.code = 'JOB_TYPE' then 1 else 0 end) job_type,
                sum(case when ar.code = 'DOB' then 1 else 0 end) dob,
                sum(case when ar.code = 'PASSPORT' then 1 else 0 end) passport,
                sum(case when ar.code = 'COUNTRY' then 1 else 0 end) country,
                sum(case when ar.code = 'NAME' then 1 else 0 end) as name
                /*sum(case when ar.code not in ('AUTHORITY_REQUEST', 'CHANGE_NEW_PASSPORT', 'JOB_TYPE', 'DOB', 'PASSPORT', 'COUNTRY', 'NAME') then 1 else 0 end) other
                count(*) total */
                from foreign_worker_amendment_reasons fwar join amendment_reasons ar on ar.id = fwar.amendment_reason_id
                join users on users.id = fwar.created_by
                join employers emp on emp.id = users.userable_id and users.userable_type = 'Employer'
                join states on states.id = emp.state_id
                where fwar.created_at >= '#{ start_date }' and fwar.created_at < '#{ end_date }'
                group by state_name order by state_name")

            nios_side = [{"branch_name"=>"HEAD QUARTERS", "authority"=>0, "new_passport"=>0, "job_type"=>0, "dob"=>2, "passport"=>4, "country"=>1, "name"=>1}, {"branch_name"=>"JOHOR BAHRU", "authority"=>0, "new_passport"=>0, "job_type"=>0, "dob"=>0, "passport"=>4, "country"=>0, "name"=>0}, {"branch_name"=>"KUALA LUMPUR", "authority"=>0, "new_passport"=>0, "job_type"=>6, "dob"=>0, "passport"=>0, "country"=>0, "name"=>1}, {"branch_name"=>"KUANTAN", "authority"=>0, "new_passport"=>0, "job_type"=>0, "dob"=>0, "passport"=>0, "country"=>0, "name"=>0}]

            portal_side =  [{"state_name"=>"JOHOR", "authority"=>0, "new_passport"=>0, "job_type"=>0, "dob"=>1, "passport"=>0, "country"=>0, "name"=>0}, {"state_name"=>"KUALA LUMPUR", "authority"=>0, "new_passport"=>0, "job_type"=>0, "dob"=>0, "passport"=>1, "country"=>0, "name"=>0}, {"state_name"=>"SELANGOR", "authority"=>0, "new_passport"=>0, "job_type"=>0, "dob"=>0, "passport"=>0, "country"=>0, "name"=>1}]
        else
            nios_side   = []
            portal_side = []
        end

        if nios_side.to_a.present? && portal_side.to_a.present?
            # Nios Side
            worksheet << {
                data: ["Branch", "Request By Authority", "Change New Passport", "Input Error"] + [""] * 4 + ["Total"],
                style: styling(bold, border, align(:v, :h, :w)) * 9
            }

            worksheet << {
                data: [""] * 3 + ["Job Type", "DOB", "Passport No", "Country", "Name", ""],
                style: styling(bold, border, align(:v, :h, :w)) * 9
            }

            nios_totals = []

            nios_side.each do |hash|
                row_sum     = hash.values[1..-1].sum
                nios_totals << hash.values[1..-1] + [row_sum]

                worksheet << {
                    data: hash.values + [row_sum],
                    style: styling(border(:l, :r)) + [{}] * 7 + styling(border(:l, :r))
                }
            end

            grand_total = nios_totals.present? ? nios_totals.transpose.map(&:sum) : [0] * 9

            worksheet << {
                data: ["TOTAL"] + grand_total,
                style: styling(border) + styling(border(:t, :b)) * 7 + styling(bold, border)
            }

            # Portal Side
            worksheet << []
            worksheet << []
            worksheet << []
            worksheet << { data: ["Portal Data Amendment Report"], style: styling(bold, align(:h)) }

            worksheet << {
                data: ["State", "Request By Authority", "Change New Passport", "Input Error"] + [""] * 4 + ["Total"],
                style: styling(bold, border, align(:v, :h, :w)) * 9
            }

            worksheet << {
                data: [""] * 3 + ["Job Type", "DOB", "Passport No", "Country", "Name", ""],
                style: styling(bold, border, align(:v, :h, :w)) * 9
            }

            portal_totals = []

            portal_side.each do |hash|
                row_sum         = hash.values[1..-1].sum
                portal_totals   << hash.values[1..-1] + [row_sum]

                worksheet << {
                    data: hash.values + [row_sum],
                    style: styling(border(:l, :r)) + [{}] * 7 + styling(border(:l, :r))
                }
            end

            grand_total = portal_totals.present? ? portal_totals.transpose.map(&:sum) : [0] * 9

            worksheet << {
                data: ["TOTAL"] + grand_total,
                style: styling(border) + styling(border(:t, :b)) * 7 + styling(bold, border)
            }

            @merge_fields   = []
            @merge_fields   << merge_fields_for_amendment_reports(1) + merge_fields_for_amendment_reports(nios_totals.size + 8)
            @column_widths  = []
            @column_widths  << [22] + [12] * 9
        end

        @filter_options = [{ type: "date range", label: "Amendment Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("total_amendment_cases#{ timestamp }")
    end

    def branch_collection
        @date = params[:date].presence
        @branch = params[:branch].presence
        @grand_total_amount = 0
        @grand_total_count = 0
        @headers = ['Payment Method', 'Slip No', 'Pieces', 'Amount (RM)']
        @branches = Organization.where(:org_type => 'BRANCH').where.not(:code => 'PT').select('id,code,name').order('name ASC')

        if @date && @branch
            @date = @date.to_date

            ## bank draft
            @bank_drafts = BankDraft
            .select('sum(amount) as total_amount, count(*) as total_count')
            .where(created_at: @date.beginning_of_day..@date.end_of_day, organization_id: @branch, holded: false, bad: false)

            @order_payments = OrderPayment.joins(:order)
            .joins('join payment_methods on orders.payment_method_id = payment_methods.id')
            .select('payment_methods.name, sum(order_payments.amount) as total_amount, count(*) as total_count')
            .where(created_at: @date.beginning_of_day..@date.end_of_day, holded: false, bad: false)
            .where(orders:{organization_id: @branch})
            .group('payment_methods.name')

            @grand_total_amount = [@bank_drafts.sum(&:total_amount), @order_payments.sum(&:total_amount)].sum
            @grand_total_count = [@bank_drafts.sum(&:total_count), @order_payments.sum(&:total_count)].sum

            ## minus voided collection by date instead
            # @voided_bank_drafts = BankDraft.select('sum(amount) as total_amount, count(*) as total_count')
            # .where(bad_at: @date.beginning_of_day..@date.end_of_day, organization_id: @branch, holded: false)

            # @voided_order_payments = OrderPayment.joins(:order)
            # .joins('join payment_methods on orders.payment_method_id = payment_methods.id')
            # .select('payment_methods.name, sum(order_payments.amount) as total_amount, count(*) as total_count')
            # .where(bad_at: @date.beginning_of_day..@date.end_of_day, holded: false)
            # .where(orders:{organization_id: @branch})
            # .group('payment_methods.name')

            # @grand_total_amount = [@bank_drafts.sum(&:total_amount), @order_payments.sum(&:total_amount), (@voided_order_payments.sum(&:total_amount)*-1),(@voided_bank_drafts.sum(&:total_amount)*-1)].sum
            # @grand_total_count = [@bank_drafts.sum(&:total_count), @order_payments.sum(&:total_count), (@voided_order_payments.sum(&:total_count)*-1),(@voided_bank_drafts.sum(&:total_count)*-1)].sum
        end
        
        template = "internal/reports/branch/#{action_name}/index"
        respond_to do |format|
            format.html { render template }
            format.xlsx { render xlsx: 'index',
                filename: "#{action_name}-#{@date}.xlsx",
                template: template }
        end
    end
private
    def merge_fields_for_amendment_reports(i)
        ["A#{ i }:I#{ i }", "A#{ i + 1 }:A#{ i + 2 }", "B#{ i + 1 }:B#{ i + 2 }", "C#{ i + 1 }:C#{ i + 2 }", "D#{ i + 1 }:H#{ i + 1 }", "I#{ i + 1 }:I#{ i + 2 }"]
    end
end