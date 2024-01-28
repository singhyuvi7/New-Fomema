# frozen_string_literal: true

module Report
  # Reporting statistic calculation for Summary Misc Income
  class SummaryMiscIncomeService
    attr_reader :order_items, :rejected_order_items

    CATEGORIES = %w[TRANSACTION_CANCELLATION
                    TRANSACTION_EXTENTION
                    FOREIGN_WORKER_AMENDMENT
                    TRANSACTION_CHANGE_DOCTOR
                    DOCTOR_REGISTRATION
                    DOCTOR_CHANGE_ADDRESS
                    LABORATORY_REGISTRATION
                    LABORATORY_CHANGE_ADDRESS
                    XRAY_FACILITY_REGISTRATION
                    XRAY_FACILITY_CHANGE_ADDRESS
                    RADIOLOGIST_REGISTRATION
                    REPRINT_MEDICAL_FORM
                    TRANSACTION_SPECIAL_RENEWAL_REJECT
                    DOCTOR_BIOMETRIC_DEVICE
                    XRAY_FACILITY_BIOMETRIC_DEVICE
                  ].freeze

    def initialize(start_date, end_date, branch_id = nil,migration_date)
      @start_date = start_date
      @end_date = end_date
      @branch_id = branch_id
      set_order_items
      set_rejected_order_items
      @migration_date = migration_date
    end

    def result
      if @start_date.to_date <= @migration_date
        @old_branch_ids = @branch_id.blank? ? Organization.where(org_type: 'BRANCH').order('name ASC').pluck(:code).join("','") : Organization.where(id: @branch_id).pluck(:code).join("','")
        [
          old_misc,
          old_statistic
        ]
      else
        [
          combined_order_items_groups,
          statistic
        ]
      end
    end

    private

    def old_misc
      misc_sql = " select to_char(rc.trandate::date, 'DD/MM/YYYY') as created_at, br.name as branchname,
      (case when rc.service_type = 'DR' then 'DOCTOR REGISTRATION'
      when rc.service_type = 'XR' then 'X-RAY REGISTRATION'
      when rc.service_type = 'LR' then 'LABORATORY REGISTRATION'
      when rc.service_type = 'RR' then 'RADIOLOGIST REGISTRATION'
      when rc.service_type = 'CA' then 'CHANGE CLINIC ADDRESS'
      end
      ) as s_type,
      ROUND(sum(rc.amount),2)::float as amount, count(1) as count
      from fomema_backup_nios.receipt rc, fomema_backup_nios.branches br
      where rc.creation_date between '#{@start_date.to_date.beginning_of_day}' and '#{@end_date.to_date.end_of_day}'
      and br.branch_code IN ('#{@old_branch_ids}')
      and rc.branch_code = br.branch_code
      and rc.service_type in ('LR','CA','XR','DR','RR')
      and rc.status != 'C' and rc.amount_paid > 0
      group by branchname, created_at, s_type
      union
      select to_char(ea.creation_date::date, 'DD/MM/YYYY') as created_at, br.name as branchname,
      (case when ea.type = 11 then 'REPRINT 4-PLY'
      when ea.type = 12 then 'DOCTOR ALLOCATION'
      when ea.type = 13 then 'WORKER CANCELLATION FEE'
      when ea.type = 15 then 'MIGRATION FEE'
      when ea.type = 16 then 'STICKER CHARGE'
      when ea.type = 25 then 'ADMIN CHARGES'
      end
      ) as s_type,
      (ROUND(sum(ea.amount),2)*-1)::float as amount, count(1) as count
      from fomema_backup_nios.employer_account ea, fomema_backup_nios.branches br
      where ea.type in (11,12,13,15,16,25)
      and br.branch_code IN ('#{@old_branch_ids}')
      and ea.branch_code = br.branch_code
      and ea.creation_date between '#{@start_date.to_date.beginning_of_day}' and '#{@end_date.to_date.end_of_day}'
      group by branchname, created_at, s_type
      order by branchname, created_at, s_type"

      misc = ActiveRecord::Base.connection.execute(misc_sql)
      @order_items = misc
      misc_arr = misc.map{|items| items.values}.to_a.map(&:flatten).group_by { |registration| registration[1] }

      return misc_arr
    end

    def order_items_count
      return {} unless @order_items

      @order_items_count ||=
        @order_items
        .group(group_attributes)
        .count
    end

    def rejected_order_items_count
      return {} unless @rejected_order_items

      @rejected_order_items_count ||=
        @rejected_order_items
        .group(['order_items.refunded_at::date', 'orders.organization_id', 'orders.category', 'order_items.fee_id'])
        .count
        .transform_values(&:-@)
    end

    def order_items_amount_sum
      return {} unless @order_items

      @order_items_amount_sum ||=
        @order_items
        .group(group_attributes)
        .order(order_attributes)
        .sum(:amount)
    end

    def rejected_order_items_amount_sum
      return {} unless @rejected_order_items
      return {} unless @start_date
      return {} unless @end_date

      @rejected_order_items_amount_sum ||=
        @rejected_order_items
        .refunded_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .group(['order_items.refunded_at::date', 'orders.organization_id', 'orders.category', 'order_items.fee_id'])
        .order(['order_items.refunded_at::date', 'orders.organization_id'])
        .sum(:amount)
        .transform_values(&:-@)
    end

    def order_items_groups
      order_items_amount_sum
        .map { |key, sum| order_item_mapping(key, sum, order_items_count) }
        .group_by { |list| list[1] }
    end

    def rejected_order_items_groups
      rejected_order_items_amount_sum
        .map { |key, sum| order_item_mapping(key, sum, rejected_order_items_count) }
        .group_by { |list| list[1] }
    end

    def combined_order_items_groups
      order_items_groups.merge(rejected_order_items_groups) { |_, group, special| group.concat special }
      .sort_by { |p| p[0] }
    end

    def statistic
      {
        grand_total: {
          total_amount: (order_items_amount_sum.values.sum + rejected_order_items_amount_sum.values.sum).to_s(:delimited),
          total_count: order_items_count.values.sum + rejected_order_items_count.values.sum
        }
      }
    end

    def old_statistic
      {
        grand_total: {
          total_amount: (@order_items.sum { |h| h['amount'] }).to_s(:delimited),
          total_count: @order_items.sum { |h| h['count'] }
        }
      }
    end

    def set_order_items
      return unless @start_date
      return unless @end_date

      @order_items = order_items_query
    end

    def set_rejected_order_items
      return unless @start_date
      return unless @end_date

      @rejected_order_items = rejected_order_items_query
    end

    def order_items_query
      OrderItem
        .joins(:fee, :order)
        .for_misc_income
        .search_organization(@branch_id)
        .paid_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
    end

    def rejected_order_items_query
      OrderItem
        .joins(:fee, :order)
        .for_misc_income
        .search_organization(@branch_id)
        .refunded_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
    end

    def group_attributes
      [
        'orders.paid_at::date',
        'orders.organization_id',
        'orders.category',
        'order_items.fee_id',
      ]
    end

    def order_attributes
      [
        'orders.paid_at::date',
        'orders.organization_id'
      ]
    end

    def decorate_attributes(data_row)
      data_row[0] = data_row[0].to_date.strftime('%d/%m/%Y')
      if data_row[3] != -0.0
        data_row[3] = Fee.find(data_row[3])&.code
      end
      data_row[2] = set_type_name(data_row[2], data_row[3])
      data_row[1] = Organization.find(data_row[1]).name
    end

    def order_item_mapping(key, sum, count)
      [key, sum, count.dig(key)]
        .flatten
        .tap { |data_row| decorate_attributes(data_row) }
    end

    def set_type_name(type_name, fee_code)
      case type_name
      when 'TRANSACTION_CANCELLATION'
        'TRANSACTION CANCELLATION'
      when 'TRANSACTION_EXTENTION'
        'TRANSACTION EXTENTION'
      when 'FOREIGN_WORKER_AMENDMENT'
        'FOREIGN WORKER AMENDMENT'
      when 'TRANSACTION_CHANGE_DOCTOR'
        'TRANSACTION CHANGE CLINIC'
      when 'DOCTOR_REGISTRATION'
        'DOCTOR REGISTRATION'
      when 'DOCTOR_CHANGE_ADDRESS'
        'CHANGE CLINIC ADDRESS'
      when 'LABORATORY_REGISTRATION'
        'LABORATORY REGISTRATION'
      when 'LABORATORY_CHANGE_ADDRESS'
        'CHANGE LABORATORY ADDRESS'
      when 'XRAY_FACILITY_REGISTRATION'
        'X-RAY FACILITY REGISTRATION'
      when 'XRAY_FACILITY_CHANGE_ADDRESS'
        'CHANGE X-RAY FACILITY ADDRESS'
      when 'RADIOLOGIST_REGISTRATION'
        'RADIOLOGIST REGISTRATION'
      when 'REPRINT_MEDICAL_FORM'
        'REPRINT 4-PLY'
      when 'TRANSACTION_SPECIAL_RENEWAL_REJECT'
        'SPECIAL RENEWAL TRANSACTION REJECTED'
      when 'DOCTOR_BIOMETRIC_DEVICE'
        if fee_code == "BIOMETRIC_DEVICE"
          'DOCTOR BIOMETRIC DEVICE'
        elsif fee_code == "BIOMETRIC_ADMIN"
          'DOCTOR BIOMETRIC ADMIN AND DEPLOYMENT FEE'
        end
      when 'XRAY_FACILITY_BIOMETRIC_DEVICE'
        if fee_code == "BIOMETRIC_DEVICE"
          'XRAY FACILITY BIOMETRIC DEVICE'
        elsif fee_code == "BIOMETRIC_ADMIN"
          'XRAY FACILITY BIOMETRIC ADMIN AND DEPLOYMENT FEE'
        end
      else
        'UNKNOWN SERVICE'
      end
    end
  end
end
