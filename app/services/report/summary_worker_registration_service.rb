# frozen_string_literal: true

module Report
  # Reporting statistic calculation for Summary Worker Registration
  class SummaryWorkerRegistrationService
    attr_reader :order_items, :data, :branches, :gender_count

    CATEGORIES = %w[TRANSACTION_REGISTRATION
                    SPECIAL_RENEWAL_TRANSACTION_REGISTRATION].freeze

    def initialize(start_date, end_date, branch_id = ni, migration_date)
      @start_date = start_date
      @end_date = end_date
      @branch_id = branch_id
      @order_items = set_order_items
      @branches = nil
      @migration_date = migration_date
    end

    def result
      if @start_date.to_date <= @migration_date
        @old_branch_ids = @branch_id.blank? ? Organization.where(org_type: 'BRANCH').order('name ASC').pluck(:code).join("','") : Organization.where(id: @branch_id).pluck(:code).join("','")
        [
          old_registration_count,
          old_gender_count_by_category
        ]
      else
        [
          registration_count,
          gender_count_by_category
        ]
      end
    end

    private

    def old_registration_count
      emp_acc_sql = "select ea.creation_date::date as tdate, br.name as branchname,
      case when ea.type = 8 then 'TRANSACTION_REGISTRATION' when ea.type = '9' then 'TRANSACTION_CANCELLATION' else 'FOREIGN_WORKER_GENDER_AMENDMENT' end as type, ea.sex as gender, count(*) as cnt
      from fomema_backup_nios.employer_account ea, fomema_backup_nios.branches br
      where ea.type in (8,9,33)
      and br.branch_code = ea.branch_code
      and ea.creation_date between '#{@start_date.to_date.beginning_of_day}' and '#{@end_date.to_date.end_of_day}'
      and br.branch_code IN ('#{@old_branch_ids}')
      group by branchname,tdate,ea.type,gender order by branchname,tdate ASC,ea.type ASC, gender ASC"

      emp_acc = ActiveRecord::Base.connection.execute(emp_acc_sql)
      emp_acc = emp_acc.map{ |items|
          if items['type'] == 'TRANSACTION_CANCELLATION'
              items['cnt'] = items['cnt']*-1
          end
          items
      }.map{|items| items.values}.to_a.map(&:flatten).group_by { |registration| registration[1] }

      return emp_acc
    end

    def old_gender_count_by_category
      total_count_sql = "select br.name as branchname,
      case when ea.type = 8 then 'TRANSACTION_REGISTRATION' when ea.type = '9' then 'TRANSACTION_CANCELLATION' else 'GENDER_CHANGE' end as type,sum(case when ea.sex = 'M' then 1 else 0 end) male_count, sum(case when ea.sex = 'F' then 1 else 0 end) female_count, count(*)
      from fomema_backup_nios.employer_account ea, fomema_backup_nios.branches br
      where ea.type in (8,9,33)
      and br.branch_code = ea.branch_code
      and ea.creation_date between '#{@start_date.to_date.beginning_of_day}' and '#{@end_date.to_date.end_of_day}'
      and br.branch_code IN ('#{@old_branch_ids}')
      group by branchname,ea.type order by branchname,ea.type ASC"

      total_count = ActiveRecord::Base.connection.execute(total_count_sql)

      types = ['TRANSACTION_REGISTRATION','TRANSACTION_CANCELLATION','GENDER_CHANGE']

      total_count = total_count.map{ |items|
          if items['type'] == 'TRANSACTION_CANCELLATION'
              items['male_count'] = items['male_count']*-1
              items['female_count'] = items['female_count']*-1
              items['count'] = items['count']*-1
          end
          items
      }.map{|items| items.values}.to_a.map(&:flatten).group_by { |registration| registration[0] }

      total_count.map do |key,array|
          types.each do |type|
              if !(array.any? {|h| h[1] == type})
                  array << [key,type, 0,0,0]
              end
          end
          array << [key,'NET', *array.map { |row_data| row_data[2..-1] }.then {|x| x.delete_at(0).zip(*x) }.map(&:sum)]
      end
      return total_count
    end

    def registration_count
      return {} unless @order_items

      @order_items
        .group(group_attributes)
        .order(order_attributes)
        .count
        .transform_keys { |items| [items.delete_at(0).strftime('%d/%m/%Y'), *items] }
        .to_a
        .map(&:flatten)
        .tap { |data| data.map { |data_row| data_row[1] = find_organization_name(data_row[1]) } }
        .map { |row_data| transform_gender_amendment(row_data) }
        .map { |row_data| transform_gender_amendment_rejected(row_data) }
        .map { |row_data| transform_cancellation(row_data) }
        .map { |row_data| transform_special_renewal_registration(row_data) }
        .group_by { |registration| registration[1] }
        .tap { |items| @branches = items.keys }
        .then do |registration_count_hash|
          registration_count_hash.merge(special_registration_cancellation_count) { |_, old, new| old.concat new }
        end
        .then do |registration_count_hash|
          registration_count_hash.merge(change_gender_registration_count) { |_, old, new| old.concat new }
        end
        .then do |registration_count_hash|
          registration_count_hash.merge(change_gender_rejected_count) { |_, old, new| old.concat new }
        end
        .then do |registration_count_hash|
          registration_count_hash.merge(change_gender_rejected_registration_count) { |_, old, new| old.concat new }
        end
        .transform_values{|array| array.group_by{|a| [a[0], a[1], a[2], a[3]]}.map{|key, value| key + [value.sum(&:last)]} }
    end

    def special_registration_cancellation_count
      return {} unless @order_items

      OrderItem
        .exclude_convenient_fee
        .exclude_insurance_fee
        .join_foreign_workers
        .for_summary_worker_registration
        .search_organization(@branch_id)
        .where(orders: { category: 'SPECIAL_RENEWAL_TRANSACTION_REGISTRATION' })
        .refunded_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .group(['order_items.refunded_at::date', 'orders.organization_id', 'orders.category', 'order_items.gender'])
        .order(['order_items.refunded_at::date', 'orders.organization_id'])
        .count
        .transform_keys { |items| [items.delete_at(0).strftime('%d/%m/%Y'), *items] }
        .to_a
        .map(&:flatten)
        .tap { |data| data.map { |data_row| data_row[1] = find_organization_name(data_row[1]) } }
        .map { |row_data| transform_special_cancellation(row_data) }
        .group_by { |registration| registration[1] }
    end

    def change_gender_registration_count
      return {} unless @order_items

      @order_items
      .where('fees.code = ?', 'FOREIGN_WORKER_GENDER_AMENDMENT')
      .paid_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
      .group(group_attributes)
      .order(order_attributes)
      .count
      .transform_keys { |items| [items.delete_at(0).strftime('%d/%m/%Y'), *items] }
      .to_a
      .map(&:flatten)
      .tap { |data| data.map { |data_row| data_row[1] = find_organization_name(data_row[1]) } }
      .map { |row_data| transform_gender_to_registration(row_data) }
      .group_by { |registration| registration[1] }
    end

    def change_gender_rejected_registration_count
      return {} unless @order_items

      OrderItem
        .exclude_convenient_fee
        .exclude_insurance_fee
        .join_foreign_workers
        .for_summary_worker_registration
        .search_organization(@branch_id)
        .where(orders: { category: 'FOREIGN_WORKER_GENDER_AMENDMENT' })
        .refunded_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .group(['order_items.refunded_at::date', 'orders.organization_id', 'orders.category', 'order_items.gender'])
        .order(['order_items.refunded_at::date', 'orders.organization_id'])
        .count
        .transform_keys { |items| [items.delete_at(0).strftime('%d/%m/%Y'), *items] }
        .to_a
        .map(&:flatten)
        .tap { |data| data.map { |data_row| data_row[1] = find_organization_name(data_row[1]) } }
        .map { |row_data| transform_gender_rejected_to_registration(row_data) }
        .group_by { |registration| registration[1] }
    end

    def change_gender_rejected_count
      return {} unless @order_items

      OrderItem
        .exclude_convenient_fee
        .exclude_insurance_fee
        .join_foreign_workers
        .for_summary_worker_registration
        .search_organization(@branch_id)
        .where(orders: { category: 'FOREIGN_WORKER_GENDER_AMENDMENT' })
        .refunded_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .group(['order_items.refunded_at::date', 'orders.organization_id', 'orders.category', 'order_items.gender'])
        .order(['order_items.refunded_at::date', 'orders.organization_id'])
        .count
        .transform_keys { |items| [items.delete_at(0).strftime('%d/%m/%Y'), *items] }
        .to_a
        .map(&:flatten)
        .tap { |data| data.map { |data_row| data_row[1] = find_organization_name(data_row[1]) } }
        .map { |row_data| transform_gender_amendment_rejected(row_data) }
        .group_by { |registration| registration[1] }
    end

    def category_gender_count
      return {} unless @order_items

      @gender_count ||=
        @order_items
        .where('orders.category IN (?) OR fees.code = ?', %w[TRANSACTION_REGISTRATION SPECIAL_RENEWAL_TRANSACTION_REGISTRATION], 'FOREIGN_WORKER_GENDER_AMENDMENT')
        .group('orders.category', 'orders.organization_id', 'order_items.gender')
        .count
    end

    def gender_count_by_category
      @branches.each_with_object({}) do |branch, summary|
        branch_id = branch.present? ? Organization.find_by(name: branch).id : nil
        CATEGORIES.map do |category|
          male_count = category_gender_count.dig([category, branch_id, 'M']).to_i
          female_count = category_gender_count.dig([category, branch_id, 'F']).to_i
          total_count = male_count.to_i + female_count.to_i
          [branch, Order::CATEGORIES[category], male_count, female_count, total_count]
        end.then do |data|
          registration = data.first
          special_renewal = data.last
          gender_change = gender_change_mapping(gender_change_count(branch_id))
          gender_change_rejected = gender_change_rejected_mapping(gender_change_rejected_count(branch_id))

          (2..4).each do |index|
            registration[index] += special_renewal[index]
            registration[index] += gender_change[index - 2]
            registration[index] += gender_change_rejected[index - 2]
          end

          [registration]
        end.tap do |data_record|
          data_record << [branch, 'TRANSACTION CANCELLATION', *gender_mapping(transaction_cancellation_count(branch_id), negative: true)]
          data_record << [branch, 'TRANSACTION REJECTION', *gender_mapping(transaction_rejection_count(branch_id), negative: true)]
          data_record << [branch, 'GENDER CHANGE', *gender_change_mapping(gender_change_count(branch_id), negative: true)]
          data_record << [branch, 'GENDER CHANGE REJECTION', *gender_change_rejected_mapping(gender_change_rejected_count(branch_id), negative: true)]
          data_record << [branch, 'NET', *data_record.map { |row_data| row_data[2..-1] }.then {|x| x.delete_at(0).zip(*x) }.map(&:sum) ]
        end.then do |collection|
          summary[branch] = collection
        end
      end
    end

    def set_order_items
      return OrderItem.none unless @start_date
      return OrderItem.none unless @end_date

      order_items_query
    end

    def order_items_query
      OrderItem
        .exclude_convenient_fee
        .exclude_insurance_fee
        .join_foreign_workers
        .for_summary_worker_registration
        .search_organization(@branch_id)
        .paid_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
    end

    def group_attributes
      [
        'orders.paid_at::date',
        'orders.organization_id',
        'orders.category',
        'order_items.gender'
      ]
    end

    def order_attributes
      [
        'orders.paid_at::date',
        'orders.organization_id'
      ]
    end

    def find_organization_name(id)
      return unless id

      Organization.find(id).name
    end

    def gender_change_count(branch_id)
      @order_items
        .where(orders: { organization_id: branch_id })
        .joins(:fee).where(fees: { code: 'FOREIGN_WORKER_GENDER_AMENDMENT' })
        .group_by(&:gender)
        .map { |k, v| [k, v.size] }
        .to_h
    end

    def gender_change_rejected_count(branch_id)
      gender_change_rejected_order_items(branch_id)
      .group_by(&:gender)
      .map { |k, v| [k, v.size] }
      .to_h
    end

    def gender_mapping(count, negative: false)
      # offset base on order item gender
      if negative
        [count.dig('M').to_i, count.dig('F').to_i, count.values.sum].map(&:-@)
      else
        [count.dig('M').to_i, count.dig('F').to_i, count.values.sum]
      end
    end

    def gender_change_mapping(count, negative: false)
      female_count = count.dig('F').to_i
      male_count = count.dig('M').to_i
      # female_offset = [-female_count, 0]
      female_offset = [0, 0].tap do |array|
        index = negative ? 0 : 1
        array[index] = negative ? -female_count : female_count
      end

      # male_offset = [0, -male_count]
      male_offset = [0, 0].tap do |array|
        index = negative ? 1 : 0
        array[index] = negative ? -male_count : male_count
      end

      male_offset
        .zip(female_offset)
        .map(&:sum)
        .tap { |data| data << data.sum }
    end

    def gender_change_rejected_mapping(count, negative: false)
      female_count = count.dig('F').to_i
      male_count = count.dig('M').to_i
      # female_offset = [female_count, 0]
      female_offset = [0, 0].tap do |array|
        index = negative ? 0 : 1
        array[index] = negative ? female_count : -female_count
    end

      # male_offset = [0, male_count]
      male_offset = [0, 0].tap do |array|
        index = negative ? 1 : 0
        array[index] = negative ? male_count : -male_count
      end

      male_offset
        .zip(female_offset)
        .map(&:sum)
        .tap { |data| data << data.sum }
    end

    def transaction_cancellation_count(branch_id)
      transaction_cancellations = @order_items.where(orders: { category: 'TRANSACTION_CANCELLATION', organization_id: branch_id })

      transaction_cancellations
        .group_by(&:gender)
        .map { |k, v| [k, v.size] }
        .to_h
    end

    def transaction_rejection_count(branch_id)
        special_rejected_order_items(branch_id)
        .group_by(&:gender)
        .map { |k, v| [k, v.size] }
        .to_h
    end

    def transform_gender_amendment(row_data)
      # display GENDER_CHANGE for FOREIGN_WORKER_AMENDMENT order type
      row_data.tap do |data|
        index = row_data.index('FOREIGN_WORKER_AMENDMENT') || row_data.index('FOREIGN_WORKER_GENDER_AMENDMENT')
        if index
          data[index] = 'GENDER_CHANGE'
          # order item gender recorded latest fw gender.
          # covert to opposite gender negative count
          data[-2] = data[-2] == 'M' ? 'F' : 'M'
          data[-1] = -data[-1]
        end
      end
    end

    def transform_gender_amendment_rejected(row_data)
      # display GENDER_CHANGE_REJECTION for rejected FOREIGN_WORKER_AMENDMENT order type
      row_data.tap do |data|
        index = row_data.index('FOREIGN_WORKER_AMENDMENT') || row_data.index('FOREIGN_WORKER_GENDER_AMENDMENT')
        if index
          data[index] = 'GENDER_CHANGE_REJECTION'
          # order item gender recorded latest fw gender.
          # covert to opposite gender negative count
          data[-2] = data[-2] == 'M' ? 'F' : 'M'
          data[-1] = data[-1]
        end
      end
    end

    def transform_cancellation(row_data)
      row_data.tap do |data|
        index = row_data.index('TRANSACTION_CANCELLATION')
        if index
          data[-1] = -data[-1]
        end
      end
    end

    def transform_special_cancellation(row_data)
      # display TRANSACTION_CANCELLATION for SPECIAL_RENEWAL_TRANSACTION_REGISTRATION cancelled order type
      row_data.tap do |data|
        index = row_data.index('SPECIAL_RENEWAL_TRANSACTION_REGISTRATION')
        if index
          data[index] = 'TRANSACTION_REJECTION'
          data[-1] = -data[-1]
        end
      end
    end

    def transform_special_renewal_registration(row_data)
      row_data.tap do |data|
        index = row_data.index('SPECIAL_RENEWAL_TRANSACTION_REGISTRATION')
        if index
          data[index] = 'TRANSACTION_REGISTRATION'
        end
      end
    end


    def special_rejected_order_items(branch_id)
      OrderItem
        .exclude_convenient_fee
        .exclude_insurance_fee
        .join_foreign_workers
        .for_summary_worker_registration
        .search_organization(@branch_id)
        .where(orders: { category: 'SPECIAL_RENEWAL_TRANSACTION_REGISTRATION', organization_id: branch_id })
        .refunded_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
    end

    def gender_change_rejected_order_items(branch_id)
      OrderItem
        .exclude_convenient_fee
        .exclude_insurance_fee
        .join_foreign_workers
        .for_summary_worker_registration
        .search_organization(@branch_id)
        .where(orders: { category: 'FOREIGN_WORKER_GENDER_AMENDMENT', organization_id: branch_id })
        .refunded_at_date_between(@start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
    end

    def transform_gender_to_registration(row_data)
      # display FOREIGN_WORKER_AMENDMENT(FEE -> FOREIGN_WORKER_GENDER_AMENDMENT) TO TRANSACTION_REGISTRATION
      row_data.tap do |data|
        index = row_data.index('FOREIGN_WORKER_AMENDMENT') || row_data.index('FOREIGN_WORKER_GENDER_AMENDMENT')
        if index
          data[index] = 'TRANSACTION_REGISTRATION'
        end
      end
    end

    def transform_gender_rejected_to_registration(row_data)
      # display FOREIGN_WORKER_AMENDMENT(FEE -> FOREIGN_WORKER_GENDER_AMENDMENT) TO TRANSACTION_REGISTRATION
      # revert TRANSACTION_REGISTRATION if FOREIGN_WORKER_GENDER_AMENDMENT is rejected
      row_data.tap do |data|
        index = row_data.index('FOREIGN_WORKER_AMENDMENT') || row_data.index('FOREIGN_WORKER_GENDER_AMENDMENT')
        if index
          data[index] = 'TRANSACTION_REGISTRATION'
          data[-1] = -data[-1]
        end
      end
    end

  end
end
