module ReportsBranchRegistration
    def pati_registration_statistics
        worksheet       = [
            data: ["Branch", "Total"],
            style: styling(bold, border) * 2
        ]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date          = params[:filter_date_start].to_date
            end_date            = params[:filter_date_end].to_date.tomorrow
            timestamp           = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"
            @extended_headers   = 2

            transactions        = ActiveRecord::Base.connection.execute("select org.name, count(*)
                from transactions t join organizations org on t.organization_id = org.id
                where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' and fw_pati = true group by org.name order by org.name")

            worksheet.unshift({
                data: ["Pati Registrations from #{ start_date.strftime("%d/%m/%Y") } to #{ end_date.strftime("%d/%m/%Y") }"],
                style: styling(bold)
            })
        else
            transactions        = []
        end

        transactions.each do |hash|
            worksheet << {
                data: [hash["name"], hash["count"]],
                style: styling(border) * 2
            }
        end

        @filter_options = [{ type: "date range", label: "Registration Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("pati_registration_statistics#{ timestamp }")
    end

    def registration_by_job_sector
        worksheet = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date          = params[:filter_date_start].to_date
            end_date            = params[:filter_date_end].to_date.tomorrow
            @extended_headers   = 4
            timestamp           = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"

            worksheet.unshift({
                data: ["Registrations from #{ start_date.strftime("%d/%m/%Y") } to #{ end_date.strftime("%d/%m/%Y") }"],
                style: styling(bold)
            })
        else
            worksheet.unshift({
                data: ["Registrations by Job Sector"],
                style: styling(bold)
            })
        end

        worksheet           = generate_table_for_job_sectors(worksheet, start_date, end_date) if start_date && end_date
        worksheet           = setting_html_display_limit(worksheet)
        row                 = worksheet.count
        @merge_fields       = []
        @merge_fields       << ["A2:A4", "B2:R2", "R3:R4", "A#{ row - 1 }:A#{ row }", "R#{ row - 1 }:R#{ row }"] + branch_merge_fields(3) + branch_merge_fields(row)
        @column_widths      = []
        @column_widths      << [25] + ([12] * 16) + [18]
        @filter_options     = [{ type: "date range", label: "Registration Date" }]
        parse_output_format("registration_by_job_sector#{ timestamp }")
    end

    def registration_breakdown
        worksheet = []

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date  = params[:filter_date_start].to_date
            end_date    = params[:filter_date_end].to_date.tomorrow
            timestamp   = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"

            worksheet.unshift({
                data: ["Registrations from #{ start_date.strftime("%d/%m/%Y") } to #{ end_date.strftime("%d/%m/%Y") }"],
                style: styling(bold)
            })
        else
            worksheet.unshift({
                data: ["Registrations Breakdown"],
                style: styling(bold)
            })
        end

        if start_date && end_date
            worksheet       = generate_table_for_plks_number(worksheet, start_date, end_date)
            row             = worksheet.count
            merge_fields    = ["A2:A4", "B2:R2", "R3:R4", "A#{ row - 1 }:A#{ row }", "R#{ row - 1 }:R#{ row }"] + branch_merge_fields(3) + branch_merge_fields(row)
            worksheet       << [""]
            worksheet       << [""]
            row             += 1 # +1 not +2 because there is no header in the first line anymore.
            merge_fields    += ["A#{ 2 + row }:A#{ 4 + row }", "B#{ 2 + row }:R#{ 2 + row }", "R#{ 3 + row }:R#{ 4 + row }"]
            merge_fields    += branch_merge_fields(3 + row)
            worksheet       = generate_table_for_job_sectors(worksheet, start_date, end_date)
            row             = worksheet.count
            merge_fields    += ["A#{ row - 1 }:A#{ row }", "R#{ row - 1 }:R#{ row }"] + branch_merge_fields(row)
            worksheet       << [""]
            worksheet       << [""]
            row             += 3
            merge_fields    += ["A#{ row }:L#{ row }", "A#{ row + 1 }:A#{ row + 2 }", "L#{ row + 1 }:L#{ row + 2 }"]
            row             += 1
            merge_fields    += ["B#{ row }:C#{ row }", "D#{ row }:E#{ row }", "F#{ row }:G#{ row }", "H#{ row }:I#{ row }", "J#{ row }:K#{ row }"]
            worksheet       = generate_table_for_country_pati_smo(worksheet, start_date, end_date)
            row             = worksheet.count
            merge_fields    += ["B#{ row }:C#{ row }", "D#{ row }:E#{ row }", "F#{ row }:G#{ row }", "H#{ row }:I#{ row }", "J#{ row }:K#{ row }"]
            merge_fields    += ["A#{ row - 1 }:A#{ row }", "L#{ row - 1 }:L#{ row }"]
        end

        @merge_fields       = []
        @merge_fields       << merge_fields
        @column_widths      = []
        @column_widths      << [35] + ([12] * 16) + [18]
        @filter_options     = [{ type: "date range", label: "Registration Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("registration_breakdown#{ timestamp }")
    end

    def new_vs_renewal
        worksheet = [
            data: ["Branch", "New", "Second Year", "Third Year", "Alternate Year", "Total"],
            style: styling(bold, border) + styling(bold, border(:t, :b)) * 4 + styling(bold, border)
        ]

        if params[:filter_date_start].present? && params[:filter_date_end].present?
            start_date          = params[:filter_date_start].to_date
            end_date            = params[:filter_date_end].to_date.tomorrow
            timestamp           = "_#{ params[:filter_date_start] }_to_#{ params[:filter_date_end] }"
            @extended_headers   = 2
            all_totals          = []

            transactions        = ActiveRecord::Base.connection.execute("select org.name,
                sum(case when t.reg_ind = 1 then 1 else 0 end) new_reg,
                sum(case when t.reg_ind = 2 then 1 else 0 end) second_year,
                sum(case when t.reg_ind = 3 then 1 else 0 end) third_year,
                sum(case when t.reg_ind > 3 then 1 else 0 end) alt_year
                from transactions t join organizations org on org.id = t.organization_id
                where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' group by org.name order by org.name")

            worksheet.unshift({
                data: ["New VS Renewal Registrations from #{ start_date.strftime("%d/%m/%Y") } to #{ end_date.strftime("%d/%m/%Y") }"],
                style: styling(bold)
            })
        else
            transactions        = []
        end

        transactions.each do |hash|
            total       = [hash["new_reg"], hash["second_year"], hash["third_year"], hash["alt_year"]]
            all_totals  << [total, total.sum].flatten

            worksheet   << {
                data: [hash["name"], total, total.sum].flatten,
                style: styling(border(:l, :r)) + [{}] * 4 + styling(border(:l, :r))
            }
        end

        if all_totals.present?
            worksheet   << {
                data: ["Total", all_totals.transpose.map(&:sum)].flatten,
                style: styling(bold, border) + styling(bold, border(:t, :b)) * 4 + styling(bold, border)
            }
        end

        @column_widths      = []
        @column_widths      << [25] + [14] * 5
        @filter_options     = [{ type: "date range", label: "Registration Date" }]
        setting_html_display_limit(worksheet)
        parse_output_format("new_vs_renewal_report#{ timestamp }")
    end

    def monthly_registration_by_branch
        worksheet           = [
            data: ["BRANCH", "NEW", "RENEWAL", "TOTAL"],
            style: styling(bold, border(:t, :l, :b)) + styling(bold, border(:t, :b)) * 2 + styling(bold, border(:t, :r, :b))
        ]

        if params[:query_month].present?
            start_date          = params[:query_month].to_date
            end_date            = start_date.next_month
            timestamp           = "_#{ start_date.strftime("%B_%Y") }"
            @extended_headers   = 2
            all_totals          = []

            transactions        = ActiveRecord::Base.connection.execute("select org.name,
                sum(case when t.reg_ind = 1 then 1 else 0 end) new_reg,
                sum(case when t.reg_ind > 1 then 1 else 0 end) renewal,
                sum(case when t.reg_ind = 1 or t.reg_ind > 1 then 1 else 0 end) total
                from transactions t join organizations org on org.id = t.organization_id
                where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' group by org.name order by org.name")

            worksheet.unshift({
                data: ["Monthly Registration Report by Branch #{ start_date.strftime("%B %Y") }"],
                style: styling(bold)
            })
        else
            transactions        = []
        end

        transactions.each do |hash|
            all_totals << hash.values[1..-1]

            worksheet << {
                data: hash.values,
                style: styling(border(:l)) + [{}] * 2 + styling(border(:r))
            }
        end

        if all_totals.present?
            worksheet << {
                data: ["Total"] + all_totals.transpose.map(&:sum),
                style: styling(border(:t, :l, :b)) + styling(border(:t, :b)) * 2 + styling(border(:t, :r, :b))
            }
        end

        @column_widths  = []
        @column_widths  << [25] + [15] * 3
        @filter_options = [{ type: "month select", label: "Registration Month" }]
        setting_html_display_limit(worksheet)
        parse_output_format("monthly_registration_by_branch#{ timestamp }")
    end

    def monthly_registration_by_job_type
        worksheet           = [
            data: ["BRANCH", "AGRICULTURE", "CONSTRUCTION", "DOMESTIC", "MANUFACTURING", "SERVICE", "PLANTATION", "MINING", "TOTAL"],
            style: styling(bold, border(:t, :l, :b)) + styling(bold, border(:t, :b)) * 7 + styling(bold, border(:t, :r, :b))
        ]

        if params[:query_month].present?
            start_date          = params[:query_month].to_date
            end_date            = start_date.next_month
            timestamp           = "_#{ start_date.strftime("%B_%Y") }"
            @extended_headers   = 2
            all_totals          = []

            transactions        = ActiveRecord::Base.connection.execute("select org.name,
                sum(case when jt.name = 'AGRICULTURE' then 1 else 0 end) agri,
                sum(case when jt.name = 'CONSTRUCTION' then 1 else 0 end) con,
                sum(case when jt.name = 'DOMESTIC' then 1 else 0 end) dom,
                sum(case when jt.name = 'MANUFACTURING' then 1 else 0 end) manu,
                sum(case when jt.name = 'SERVICE' then 1 else 0 end) serv,
                sum(case when jt.name = 'PLANTATION' then 1 else 0 end) plant,
                sum(case when jt.name = 'MINING' then 1 else 0 end) mine
                from transactions t join organizations org on org.id = t.organization_id
                join job_types jt on jt.id = t.fw_job_type_id
                where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' group by org.name order by org.name")

            worksheet.unshift({
                data: ["Monthly Registration Report by Job Type #{ start_date.strftime("%B %Y") }"],
                style: styling(bold)
            })
        else
            transactions        = []
        end

        transactions.each do |hash|
            all_totals << hash.values[1..-1]

            worksheet << {
                data: hash.values + [hash.values[1..-1].sum],
                style: styling(border(:l)) + [{}] * 7 + styling(border(:r))
            }
        end

        if all_totals.present?
            worksheet << {
                data: ["Total"] + all_totals.transpose.map(&:sum) + [all_totals.flatten.sum],
                style: styling(border(:t, :l, :b)) + styling(border(:t, :b)) * 7 + styling(border(:t, :r, :b))
            }
        end

        @column_widths  = []
        @column_widths  << [25] + [15] * 3
        @filter_options = [{ type: "month select", label: "Registration Month" }]
        setting_html_display_limit(worksheet)
        parse_output_format("monthly_registration_by_job_type#{ timestamp }")
    end

    def statistic_male_female
        @branches = Organization.where(:org_type => 'BRANCH').select('id,code,name').order('name ASC')
        migration_date = '2020-10-28'.to_date 

        @headers = []
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @branch_id = params[:branch]

        if @start_date && @end_date
            @start_date = @start_date.to_date
            @end_date = @end_date.to_date

            if @start_date.to_date <= migration_date
                old_branch_ids = @branch_id.blank? ? Organization.where(org_type: 'BRANCH').order('name ASC').pluck(:code).join("','") : Organization.where(id: @branch_id).pluck(:code).join("','")

                ## need to get sql from fomema
                emp_acc_sql = "select ea.creation_date::date as tdate, br.name as branchname, 
                case when ea.type = 8 then 'TRANSACTION_REGISTRATION' when ea.type = '9' then 'TRANSACTION_CANCELLATION' else 'FOREIGN_WORKER_GENDER_AMENDMENT' end as type, ea.sex as gender, count(*) as cnt
                from fomema_backup_nios.employer_account ea, fomema_backup_nios.branches br 
                where ea.type in (8,9,33)
                and br.branch_code = ea.branch_code 
                and ea.creation_date between '#{@start_date.beginning_of_day}' and '#{@end_date.end_of_day}' 
                and br.branch_code IN ('#{old_branch_ids}')
                group by branchname,tdate,ea.type,gender order by branchname,tdate ASC,ea.type ASC, gender ASC"
            
                emp_acc = ActiveRecord::Base.connection.execute(emp_acc_sql)

                render json: emp_acc and return
            else
                @order_items = OrderItem.joins(:fee)
                .joins(:order)
                .joins('join organizations on orders.organization_id = organizations.id')
                .select("organizations.name as branch_name, 
                sum(case when gender = 'F' then 1 else 0 end) as female_count,
                sum(case when gender = 'M' then 1 else 0 end) as male_count,
                sum(case when gender = 'F' then order_items.amount else 0 end) as female_amount,
                sum(case when gender = 'M' then order_items.amount else 0 end) as male_amount")
                .merge(Order.search_organization(@branch_id))
                .where(fees: {code: ['TRANSACTION_MALE','TRANSACTION_FEMALE']})
                .where(orders: {status: 'PAID', paid_at: @start_date.beginning_of_day..@end_date.end_of_day})
                .group('branch_name')
    
                @gender_changes = OrderItem.joins(:order)
                .joins('join organizations on orders.organization_id = organizations.id')
                .joins("join transactions on (order_items.additional_information->>'transaction_id')::bigint = transactions.id")
                .joins("join order_items as register_items on transactions.order_item_id = register_items.id")
                .joins("left join refund_items on transactions.foreign_worker_id = refund_items.refund_itemable_id")
                .joins("left join refunds on refund_items.refund_id = refunds.id")
                .select("organizations.name as branch_name, 
                sum(case when order_items.gender = 'F' then 1 else -1 end) as female_count,
                sum(case when order_items.gender = 'M' then 1 else -1 end) as male_count,
                sum(case when order_items.gender = 'F' then (order_items.amount+register_items.amount) else (register_items.amount*-1) end) as female_amount,
                sum(case when order_items.gender = 'M' then (register_items.amount-refund_items.amount) else (register_items.amount*-1) end) as male_amount")
                .merge(Order.search_organization(@branch_id))
                .where(orders: {status: 'PAID', paid_at: @start_date.beginning_of_day..@end_date.end_of_day, category: 'FOREIGN_WORKER_GENDER_AMENDMENT'})
                .group('branch_name')
    
                @gender_changes = @gender_changes.map { |gender_change| [
                        gender_change.branch_name,
                        gender_change.female_count,
                        gender_change.male_count,
                        gender_change.female_amount,
                        gender_change.male_amount
                    ] }
                    .group_by { |data| data[0] }  if !@gender_changes.blank?
    
                # .where("refunds.category = 'FOREIGN_WORKER_GENDER_AMENDMENT'")
    
                @cancellations = Transaction.joins(:transaction_cancels).joins(:organization).joins(:order_item)
                .select("organizations.name as branch_name, 
                sum(case when fw_gender = 'F' then 1 else 0 end) as female_count,
                sum(case when fw_gender = 'M' then 1 else 0 end) as male_count,
                sum(case when fw_gender = 'F' then order_items.amount else 0 end) as female_amount,
                sum(case when fw_gender = 'M' then order_items.amount else 0 end) as male_amount")
                .where(transaction_cancels:{cancelled_at: @start_date.beginning_of_day..@end_date.end_of_day})
                .search_organization(@branch_id)
                .group('branch_name')
    
                @cancellations = @cancellations.map { |cancellation| [
                        cancellation.branch_name,
                        cancellation.female_count,
                        cancellation.male_count,
                        cancellation.female_amount,
                        cancellation.male_amount
                    ] }
                    .group_by { |data| data[0] }  if !@cancellations.blank?
    
                @rejections = Transaction.joins(:organization).joins(:order_item)
                .select("organizations.name as branch_name, 
                sum(case when fw_gender = 'F' then 1 else 0 end) as female_count,
                sum(case when fw_gender = 'M' then 1 else 0 end) as male_count,
                sum(case when fw_gender = 'F' then order_items.amount else 0 end) as female_amount,
                sum(case when fw_gender = 'M' then order_items.amount else 0 end) as male_amount")
                .where(special_renewal_rejected_at: @start_date.beginning_of_day..@end_date.end_of_day)
                .search_organization(@branch_id)
                .group('branch_name')
    
                @rejections = @rejections.map { |rejection| [
                        rejection.branch_name,
                        rejection.female_count,
                        rejection.male_count,
                        rejection.female_amount,
                        rejection.male_amount
                    ] }
                    .group_by { |data| data[0] }  if !@rejections.blank?
    
                @order_items = @order_items.map { |order_item| 
                    branch_name = order_item.branch_name
    
                    if !@gender_changes.blank?
                        order_item.female_count = order_item.female_count + (@gender_changes[branch_name].blank? ? 0 : @gender_changes[branch_name][0][1])
                        order_item.male_count = order_item.male_count + (@gender_changes[branch_name].blank? ? 0 : @gender_changes[branch_name][0][2])
                        order_item.female_amount = order_item.female_amount + (@gender_changes[branch_name].blank? ? 0 : @gender_changes[branch_name][0][3])
                        order_item.male_amount = order_item.male_amount + (@gender_changes[branch_name].blank? ? 0 : @gender_changes[branch_name][0][4])
                    end
    
                    if !@cancellations.blank?
                        order_item.female_count = order_item.female_count - (@cancellations[branch_name].blank? ? 0 : @cancellations[branch_name][0][1])
                        order_item.male_count = order_item.male_count - (@cancellations[branch_name].blank? ? 0 : @cancellations[branch_name][0][2])
                        order_item.female_amount = order_item.female_amount - (@cancellations[branch_name].blank? ? 0 : @cancellations[branch_name][0][3])
                        order_item.male_amount = order_item.male_amount - (@cancellations[branch_name].blank? ? 0 : @cancellations[branch_name][0][4])
                    end
    
                    if !@rejections.blank?
                        order_item.female_count = order_item.female_count - (@rejections[branch_name].blank? ? 0 : @rejections[branch_name][0][1])
                        order_item.male_count = order_item.male_count - (@rejections[branch_name].blank? ? 0 : @rejections[branch_name][0][2])
                        order_item.female_amount = order_item.female_amount - (@rejections[branch_name].blank? ? 0 : @rejections[branch_name][0][3])
                        order_item.male_amount = order_item.male_amount - (@rejections[branch_name].blank? ? 0 : @rejections[branch_name][0][4])
                    end
    
                    order_item
                }
    
                @grand_female_count = @order_items.sum(&:female_count)
                @grand_male_count = @order_items.sum(&:male_count)
                @grand_female_amount = @order_items.sum(&:female_amount)
                @grand_male_amount = @order_items.sum(&:male_amount)
                @grand_total_count = @grand_female_count+@grand_male_count
                @grand_total_amount = @grand_female_amount+@grand_male_amount
            end
        end

        template = "internal/reports/branch/#{action_name}/index"
        respond_to do |format|
            format.html { render template }
            format.xlsx { render xlsx: 'index',
                filename: "#{action_name}-#{@date}.xlsx",
                template: template }
        end
    end

    def input_error_critical_amendment
        if params[:date_from].blank? || params[:date_to].blank?
            flash.now[:error] = "Filter criteria is required"
            render 'internal/reports/branch/input_error_critical_amendment/index' and return
        end

        @fw_amendments = FwAmendment.joins(:foreign_worker).joins("join fw_amendment_reasons on fw_amendments.id = fw_amendment_reasons.fw_amendment_id
        join amendment_reasons on fw_amendment_reasons.amendment_reason_id = amendment_reasons.id and amendment_reasons.code = 'INPUT_ERROR'
        left join users creator_users on creator_users.id = foreign_workers.created_by
        left join users amendment_users on amendment_users.id = fw_amendments.created_by
        left join fw_amendment_details fwad_name on fwad_name.fw_amendment_id = fw_amendments.id and fwad_name.field = 'name'
        left join fw_amendment_details fwad_passport_number on fwad_passport_number.fw_amendment_id = fw_amendments.id and fwad_passport_number.field = 'passport_number'
        left join fw_amendment_details fwad_gender on fwad_gender.fw_amendment_id = fw_amendments.id and fwad_gender.field = 'gender'
        left join fw_amendment_details fwad_date_of_birth on fwad_date_of_birth.fw_amendment_id = fw_amendments.id and fwad_date_of_birth.field = 'date_of_birth'
        left join fw_amendment_details fwad_country_id on fwad_country_id.fw_amendment_id = fw_amendments.id and fwad_country_id.field = 'country_id'")
        .select("fw_amendments.id, fw_amendments.foreign_worker_id, 
        foreign_workers.created_by fw_created_by, creator_users.name fw_created_by_name, foreign_workers.created_at fw_created_at, 
        fw_amendments.created_by amendment_by, amendment_users.name amendment_by_name, fw_amendments.created_at amendment_at, 
        foreign_workers.code fw_code, foreign_workers.organization_id, 
        fwad_name.old_value name_old_value, fwad_name.new_value name_new_value, 
        fwad_passport_number.old_value passport_number_old_value, fwad_passport_number.new_value passport_number_new_value, 
        fwad_gender.old_value gender_old_value, fwad_gender.new_value gender_new_value, 
        fwad_date_of_birth.old_value date_of_birth_old_value, fwad_date_of_birth.new_value date_of_birth_new_value, 
        fwad_country_id.old_value country_id_old_value, fwad_country_id.new_value country_id_new_value")
        .where("fw_amendments.created_at between ? and ?", params[:date_from].to_date.beginning_of_day, params[:date_to].to_date.end_of_day)
        if !params[:organization_id].blank?
            @fw_amendments = @fw_amendments.where("foreign_workers.organization_id" => params[:organization_id])
        end
=begin
select fw_amendments.id, fw_amendments.foreign_worker_id, 
foreign_workers.created_by fw_created_by, creator_users.name fw_created_by_name, foreign_workers.created_at fw_created_at, 
fw_amendments.created_by amendment_by, amendment_users.name amendment_by_name, fw_amendments.created_at amendment_at, 
foreign_workers.code fw_code, foreign_workers.organization_id, 
fwad_name.old_value name_old_value, fwad_name.new_value name_new_value, 
fwad_passport_number.old_value passport_number_old_value, fwad_passport_number.new_value passport_number_new_value, 
fwad_gender.old_value gender_old_value, fwad_gender.new_value gender_new_value, 
fwad_date_of_birth.old_value date_of_birth_old_value, fwad_date_of_birth.new_value date_of_birth_new_value, 
fwad_country_id.old_value country_id_old_value, fwad_country_id.new_value country_id_new_value
from fw_amendments join fw_amendment_reasons on fw_amendments.id = fw_amendment_reasons.fw_amendment_id
join amendment_reasons on fw_amendment_reasons.amendment_reason_id = amendment_reasons.id and amendment_reasons.code = 'INPUT_ERROR'
join foreign_workers on fw_amendments.foreign_worker_id = foreign_workers.id
left join users creator_users on creator_users.id = foreign_workers.created_by
left join users amendment_users on amendment_users.id = fw_amendments.created_by
left join fw_amendment_details fwad_name on fwad_name.fw_amendment_id = fw_amendments.id and fwad_name.field = 'name'
left join fw_amendment_details fwad_passport_number on fwad_passport_number.fw_amendment_id = fw_amendments.id and fwad_passport_number.field = 'passport_number'
left join fw_amendment_details fwad_gender on fwad_gender.fw_amendment_id = fw_amendments.id and fwad_gender.field = 'gender'
left join fw_amendment_details fwad_date_of_birth on fwad_date_of_birth.fw_amendment_id = fw_amendments.id and fwad_date_of_birth.field = 'date_of_birth'
left join fw_amendment_details fwad_country_id on fwad_country_id.fw_amendment_id = fw_amendments.id and fwad_country_id.field = 'country_id'
=end

        respond_to do |format|
            format.html do
                @fw_amendments = @fw_amendments.page(params[:page]).per(get_per)
                render 'internal/reports/branch/input_error_critical_amendment/index'
            end
            format.pdf do
                @company_name = SystemConfiguration.get('COMPANY_NAME')
                @current = Time.now
                render pdf: "input_error_critical_amendment",
                template: 'internal/reports/branch/input_error_critical_amendment/pdf_template.html.erb',
                layout: "pdf.html",
                margin: {
                    top: 40,
                    left: 12,
                    right: 12,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "21cm",
                page_width: "29.7cm",
                dpi: "300",
                header: {
                    html: {
                        template: '/internal/reports/branch/input_error_critical_amendment/pdf_template_header'
                    }
                }
            end
        end
    end

private
    def generate_table_for_job_sectors(worksheet, start_date, end_date)
        transactions        = []
        job_types           = ["agri", "con", "dom", "manu", "serv", "plant", "mine"]
        all_totals          = []

        transactions        = ActiveRecord::Base.connection.execute("select org.name,
            sum(case when jt.name = 'AGRICULTURE' and t.fw_gender = 'M' then 1 else 0 end) agri_job_m,
            sum(case when jt.name = 'AGRICULTURE' and t.fw_gender = 'F' then 1 else 0 end) agri_job_f,
            sum(case when jt.name = 'CONSTRUCTION' and t.fw_gender = 'M' then 1 else 0 end) con_job_m,
            sum(case when jt.name = 'CONSTRUCTION' and t.fw_gender = 'F' then 1 else 0 end) con_job_f,
            sum(case when jt.name = 'DOMESTIC' and t.fw_gender = 'M' then 1 else 0 end) dom_job_m,
            sum(case when jt.name = 'DOMESTIC' and t.fw_gender = 'F' then 1 else 0 end) dom_job_f,
            sum(case when jt.name = 'MANUFACTURING' and t.fw_gender = 'M' then 1 else 0 end) manu_job_m,
            sum(case when jt.name = 'MANUFACTURING' and t.fw_gender = 'F' then 1 else 0 end) manu_job_f,
            sum(case when jt.name = 'SERVICE' and t.fw_gender = 'M' then 1 else 0 end) serv_job_m,
            sum(case when jt.name = 'SERVICE' and t.fw_gender = 'F' then 1 else 0 end) serv_job_f,
            sum(case when jt.name = 'PLANTATION' and t.fw_gender = 'M' then 1 else 0 end) plant_job_m,
            sum(case when jt.name = 'PLANTATION' and t.fw_gender = 'F' then 1 else 0 end) plant_job_f,
            sum(case when jt.name = 'MINING' and t.fw_gender = 'M' then 1 else 0 end) mine_job_m,
            sum(case when jt.name = 'MINING' and t.fw_gender = 'F' then 1 else 0 end) mine_job_f
            from transactions t join organizations org on t.organization_id = org.id
            join job_types jt on jt.id = t.fw_job_type_id
            where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' group by org.name")

        worksheet << {
            data: ["BRANCH", "SECTOR"] + [""] * 16,
            style: styling(bold, border, align(:h, :v)) + styling(bold, border, align(:h)) * 17
        }

        worksheet << {
            data: [[""] * 9, ["AGRICULTURE", "CONSTRUCTION", "DOMESTIC", "MANUFACTURING", "SERVICE", "PLANTATION", "MINING", "TOTAL", "GRAND TOTAL"]].transpose.flatten,
            style: styling(bold, border(:l, :r), align(:h, :v)) * 18
        }

        worksheet << {
            data: [""] + ["MALE", "FEMALE"] * 8 + [""],
            style: [styling(bold, border(:l, :b)) * 10, ([nil] + styling(bold, border(:b)) * 8 + [nil])].transpose.flatten.compact
        }

        transactions.each do |hash|
            totals = [
                job_types.map {|type| [hash["#{ type }_job_m"], hash["#{ type }_job_f"]] },
                job_types.map {|type| hash["#{ type }_job_m"] }.sum,
                job_types.map {|type| hash["#{ type }_job_f"] }.sum,
                job_types.map {|type| hash["#{ type }_job_m"] + hash["#{ type }_job_f"] }.sum
            ].flatten

            all_totals << totals

            worksheet << {
                data: [hash["name"]] + totals,
                style: [styling(border(:l)) * 9 + styling(border(:l, :r), align(:h, :v)), [nil] + [{}] * 8 + [nil]].transpose.flatten.compact
            }
        end

        if all_totals.present?
            worksheet << {
                data: ["TOTAL"] + all_totals.transpose.map(&:sum),
                style: [
                    styling(border(:l, :t), align(:h, :v)) +
                    styling(border(:l, :t)) * 8 +
                    styling(border(:l, :r, :t), align(:h, :v)),
                    [nil] + styling(border(:t)) * 8 + [nil]
                ].transpose.flatten.compact
            }

            worksheet << {
                data: [[""] * 8, all_totals.transpose.map(&:sum)[0..-2].each_slice(2).to_a.map(&:sum)].transpose.flatten + ["", ""],
                style: [
                    styling(border(:l, :b), align(:h)) * 9 +
                    styling(border(:l, :r, :b)),
                    [nil] + styling(border(:b), align(:h)) * 8 + [nil]
                ].transpose.flatten.compact
            }
        end

        worksheet
    end

    def generate_table_for_plks_number(worksheet, start_date, end_date)
        transactions        = []
        plks_types          = ["zero", "one", "two", "three", "four", "five", "other"]
        all_totals          = []

        transactions        = ActiveRecord::Base.connection.execute("select org.name,
            sum(case when (t.fw_plks_number is null or t.fw_plks_number::integer = 0) and t.fw_gender = 'M' then 1 else 0 end) zero_m,
            sum(case when (t.fw_plks_number is null or t.fw_plks_number::integer = 0) and t.fw_gender = 'F' then 1 else 0 end) zero_f,
            sum(case when t.fw_plks_number::integer = 1 and t.fw_gender = 'M' then 1 else 0 end) one_m,
            sum(case when t.fw_plks_number::integer = 1 and t.fw_gender = 'F' then 1 else 0 end) one_f,
            sum(case when t.fw_plks_number::integer = 2 and t.fw_gender = 'M' then 1 else 0 end) two_m,
            sum(case when t.fw_plks_number::integer = 2 and t.fw_gender = 'F' then 1 else 0 end) two_f,
            sum(case when t.fw_plks_number::integer = 3 and t.fw_gender = 'M' then 1 else 0 end) three_m,
            sum(case when t.fw_plks_number::integer = 3 and t.fw_gender = 'F' then 1 else 0 end) three_f,
            sum(case when t.fw_plks_number::integer = 4 and t.fw_gender = 'M' then 1 else 0 end) four_m,
            sum(case when t.fw_plks_number::integer = 4 and t.fw_gender = 'F' then 1 else 0 end) four_f,
            sum(case when t.fw_plks_number::integer = 5 and t.fw_gender = 'M' then 1 else 0 end) five_m,
            sum(case when t.fw_plks_number::integer = 5 and t.fw_gender = 'F' then 1 else 0 end) five_f,
            sum(case when t.fw_plks_number::integer > 5  and t.fw_gender = 'M' then 1 else 0 end) other_m,
            sum(case when t.fw_plks_number::integer > 5 and t.fw_gender = 'F' then 1 else 0 end) other_f
            from transactions t join organizations org on t.organization_id = org.id
            where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' group by org.name")

        worksheet << {
            data: ["BRANCH", "PLKS NO"] + [""] * 16,
            style: styling(bold, border, align(:h, :v)) + styling(bold, border, align(:h)) * 17
        }

        worksheet << {
            data: [[""] * 9, [0, 1, 2, 3, 4, 5, "OTHERS", "TOTAL", "GRAND TOTAL"]].transpose.flatten,
            style: styling(bold, border(:l, :r), align(:h, :v)) * 18
        }

        worksheet << {
            data: [""] + ["MALE", "FEMALE"] * 8 + [""],
            style: [styling(bold, border(:l, :b)) * 10, ([nil] + styling(bold, border(:b)) * 8 + [nil])].transpose.flatten.compact
        }

        transactions.each do |hash|
            totals = [
                plks_types.map {|type| [hash["#{ type }_m"], hash["#{ type }_f"]] },
                plks_types.map {|type| hash["#{ type }_m"] }.sum,
                plks_types.map {|type| hash["#{ type }_f"] }.sum,
                plks_types.map {|type| hash["#{ type }_m"] + hash["#{ type }_f"] }.sum
            ].flatten

            all_totals << totals

            worksheet << {
                data: [hash["name"]] + totals,
                style: [styling(border(:l)) * 9 + styling(border(:l, :r), align(:h, :v)), [nil] + [{}] * 8 + [nil]].transpose.flatten.compact
            }
        end

        if all_totals.present?
            worksheet << {
                data: ["TOTAL"] + all_totals.transpose.map(&:sum),
                style: [
                    styling(border(:l, :t), align(:h, :v)) +
                    styling(border(:l, :t)) * 8 +
                    styling(border(:l, :r, :t), align(:h, :v)),
                    [nil] + styling(border(:t)) * 8 + [nil]
                ].transpose.flatten.compact
            }

            worksheet << {
                data: [[""] * 8, all_totals.transpose.map(&:sum)[0..-2].each_slice(2).to_a.map(&:sum)].transpose.flatten + ["", ""],
                style: [
                    styling(border(:l, :b), align(:h)) * 9 +
                    styling(border(:l, :r, :b)),
                    [nil] + styling(border(:b), align(:h)) * 8 + [nil]
                ].transpose.flatten.compact
            }
        end

        worksheet
    end

    def generate_table_for_country_pati_smo(worksheet, start_date, end_date)
        transactions        = []
        list_types          = ["normal", "smo", "pati", "rtk"]
        all_totals          = []

        transactions        = ActiveRecord::Base.connection.execute("select countries.name,
            sum(case when (t.fw_pati is not true or t.fw_maid_online != 'PRAON') and t.fw_gender = 'M' then 1 else 0 end) normal_m,
            sum(case when (t.fw_pati is not true or t.fw_maid_online != 'PRAON') and t.fw_gender = 'F' then 1 else 0 end) normal_f,
            sum(case when t.fw_maid_online = 'PRAON' and t.fw_gender = 'M' then 1 else 0 end) smo_m,
            sum(case when t.fw_maid_online = 'PRAON' and t.fw_gender = 'F' then 1 else 0 end) smo_f,
            sum(case when t.fw_pati = true and t.fw_gender = 'M' then 1 else 0 end) pati_m,
            sum(case when t.fw_pati = true and t.fw_gender = 'F' then 1 else 0 end) pati_f,
            sum(case when t.fw_maid_online = 'RTK' and t.fw_gender = 'M' then 1 else 0 end) rtk_m,
            sum(case when t.fw_maid_online = 'RTK' and t.fw_gender = 'F' then 1 else 0 end) rtk_f
            from transactions t join countries on countries.id = t.fw_country_id
            where t.transaction_date >= '#{ start_date }' and t.transaction_date < '#{ end_date }' group by countries.name")

        worksheet << {
            data: ["COUNTRY/PATI/SMO"] + [""] * 11,
            style: styling(bold, border, align(:h)) * 12
        }

        worksheet << {
            data: ["COUNTRY"] + [["NORMAL REGISTRATION", "SMO", "PATI", "RTK", "TOTAL"], [""] * 5].transpose.flatten + ["GRAND TOTAL"],
            style: styling(bold, border(:t, :l, :r), align(:h, :v, :w)) * 12
        }

        worksheet << {
            data: [""] + ["MALE", "FEMALE"] * 5 + [""],
            style: styling(bold, border) + ([styling(bold, border(:l, :b)), styling(bold, border(:b))] * 5).flatten + styling(bold, border)
        }

        transactions.each do |hash|
            totals = [
                list_types.map {|type| [hash["#{ type }_m"], hash["#{ type }_f"]] },
                list_types.map {|type| hash["#{ type }_m"] }.sum,
                list_types.map {|type| hash["#{ type }_f"] }.sum,
                list_types.map {|type| hash["#{ type }_m"] + hash["#{ type }_f"] }.sum
            ].flatten

            all_totals << totals

            worksheet << {
                data: [hash["name"]] + totals,
                style: styling(border(:l, :r, :w)) + [styling(border(:l)) * 5, [{}] * 5].transpose.flatten + styling(border(:l, :r))
            }
        end

        if all_totals.present?
            worksheet << {
                data: ["TOTAL"] + all_totals.transpose.map(&:sum),
                style: styling(border(:l, :t), align(:h, :v)) + [styling(border(:l, :t)) * 5, styling(border(:t)) * 5].transpose.flatten + styling(border(:l, :r, :t), align(:h, :v))
            }

            worksheet << {
                data: [[""] * 5, all_totals.transpose.map(&:sum)[0..-2].each_slice(2).to_a.map(&:sum)].transpose.flatten + ["", ""],
                style: styling(border(:l, :b), align(:h)) * 11 + styling(border(:l, :r, :b))
            }
        end

        worksheet
    end

    def branch_merge_fields(row)
        ["B#{ row }:C#{ row }", "D#{ row }:E#{ row }", "F#{ row }:G#{ row }", "H#{ row }:I#{ row }", "J#{ row }:K#{ row }", "L#{ row }:M#{ row }", "N#{ row }:O#{ row }", "P#{ row }:Q#{ row }"]
    end
end