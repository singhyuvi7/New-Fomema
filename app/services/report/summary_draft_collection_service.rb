# frozen_string_literal: true

module Report
  # summary draft collection reporting service
  class SummaryDraftCollectionService
    attr_reader :bank_drafts
    attr_reader :order_payments
    attr_reader :voided_order_payments
    attr_reader :voided_bank_drafts
    attr_reader :ipays
    attr_reader :swipes
    attr_reader :fpxs
    attr_reader :bolehs

    def initialize(start_date, end_date, branch_id)
      @start_date = start_date + '+8'
      @end_date = end_date + '+8'
      @branch_id = branch_id
      @bank_drafts = set_bank_drafts
      @order_payments = set_order_payments
      @voided_order_payments = set_voided_order_payments
      @voided_bank_drafts = set_voided_bank_drafts
      @ipays = set_ipays
      @swipes = set_swipes
      @fpxs = set_fpxs
      @bolehs = set_bolehs
    end

    def result
      [merged_data, grand_total]
    end

    private

    def bank_draft_grouping
      @bank_draft_grouping ||=
        bank_drafts
        .map { |bank_draft| bank_draft_mapping(bank_draft) }
        .group_by { |data| data[1] }
    end

    def grand_total
      []
        .tap { |grand_total| grand_total_mapping(grand_total) }
        .then { |data| @grand_total ||= data }
    end

    def set_bank_drafts
      return BankDraft.none unless @start_date.present? && @end_date.present?

      BankDraft
        .select('organization_id, sum(amount) as amount, sum(gst_amount) as gst_amount, sum(process_fee) as process_fee,created_at::date')
        .where('created_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .where(:payerable_type => ['Employer'])
        .where.not(:sync_date => nil)
        .search_organization(@branch_id)
        .group('created_at::date, organization_id')
        .order('created_at ASC')
    end

    def bank_draft_mapping(bank_draft)
      net_amount = bank_draft.amount
      gst_amount = bank_draft.gst_amount
      processing_fee = bank_draft.process_fee
      draft_amount = bank_draft.amount
      [
        bank_draft.created_at.try(:strftime, '%d/%m/%Y'),
        Organization.find(bank_draft.organization_id).name,
        net_amount,
        gst_amount,
        processing_fee,
        draft_amount
      ]
    end

    def grand_total_mapping(grand_total_data)
      ipay_process_fees = ipays.map{|x| x[:process_fee]}
      swipe_process_fees = swipes.map{|x| x[:process_fee]}
      fpx_process_fees = fpxs.map{|x| x[:process_fee]}
      boleh_process_fees = bolehs.map{|x| x[:process_fee]}

      total_draft_amount = [bank_drafts.pluck(:amount).sum, order_payments.pluck(:amount).sum, ipays.pluck(:amount).sum, swipes.pluck(:amount).sum, fpxs.pluck(:amount).sum, bolehs.pluck(:amount).sum, voided_order_payments.pluck(:amount).sum, voided_bank_drafts.pluck(:amount).sum, ipay_process_fees.sum, swipe_process_fees.sum, fpx_process_fees.sum, boleh_process_fees.sum].sum
      total_gst_amount = [bank_drafts.pluck(:gst_amount).sum, order_payments.pluck(:gst_amount).sum].sum
      total_processing_fees = [bank_drafts.pluck(:process_fee).sum, order_payments.pluck(:process_fee).sum, ipay_process_fees.sum, swipe_process_fees.sum, fpx_process_fees.sum, boleh_process_fees.sum].sum
      total_net_amount = total_draft_amount-total_processing_fees

      grand_total_data.tap do |data|
        data << total_net_amount         # total_net_amount
        data << total_gst_amount           # total_gst_amount
        data << total_processing_fees      # total_processing_fees
        data << total_draft_amount         # total_draft_amount
      end
    end

    ## order payments
    def set_order_payments
      return OrderPayment.none unless @start_date.present? && @end_date.present?

      OrderPayment
        .joins(:order)
        .select('orders.organization_id, sum(order_payments.amount) as amount,sum(gst_amount) as gst_amount, sum(process_fee) as process_fee,orders.paid_at::date as created_at')
        .where('orders.paid_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .where(orders: {customerable_type: ['Employer']})
        .where.not(:sync_date => nil)
        .search_organization(@branch_id)
        .group('orders.paid_at::date, orders.organization_id')
        .order('orders.paid_at::date ASC')
    end

    def order_payment_grouping
      @order_payment_grouping ||=
        order_payments
        .map { |order_payment| order_payment_mapping(order_payment) }
        .group_by { |data| data[1] }
    end

    def order_payment_mapping(order_payment)
      net_amount = order_payment.amount
      gst_amount = order_payment.gst_amount
      processing_fee = order_payment.process_fee
      draft_amount = order_payment.amount
      [
        order_payment.created_at.try(:strftime, '%d/%m/%Y'),
        Organization.find(order_payment.organization_id).try(:name),
        net_amount,
        gst_amount,
        processing_fee,
        draft_amount
      ]
    end

    def set_voided_order_payments
      return OrderPayment.none unless @start_date.present? && @end_date.present?

      OrderPayment
        .joins(:order)
        .select('orders.organization_id, (sum(order_payments.amount)*-1) as amount,(sum(gst_amount)*-1) as gst_amount, (sum(process_fee)*-1) as process_fee,order_payments.bad_at::date as created_at')
        .where('order_payments.bad_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .where(orders: {customerable_type: ['Employer']})
        .where.not(:sync_date => nil)
        .where.not(:sync_bad_date => nil)
        .search_organization(@branch_id)
        .group('order_payments.bad_at::date, orders.organization_id')
        .order('order_payments.bad_at::date ASC')
    end

    def voided_order_payment_grouping
      @voided_order_payment_grouping ||=
        voided_order_payments
        .map { |order_payment| order_payment_mapping(order_payment) }
        .group_by { |data| data[1] }
    end

    def set_voided_bank_drafts
      return BankDraft.none unless @start_date.present? && @end_date.present?

      BankDraft
        .select('organization_id, (sum(amount)*-1) as amount,(sum(gst_amount)*-1) as gst_amount, (sum(process_fee)*-1) as process_fee, bad_at::date as created_at')
        .where('bad_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
        .where(:payerable_type => ['Employer'])
        .where.not(:sync_date => nil)
        .where.not(:sync_bad_date => nil)
        .search_organization(@branch_id)
        .group('bad_at::date, organization_id')
        .order('bad_at::date ASC')
    end

    def voided_bank_draft_grouping
      @voided_bank_draft_grouping ||=
        voided_bank_drafts
        .map { |bank_draft| bank_draft_mapping(bank_draft) }
        .group_by { |data| data[1] }
    end

    def set_ipays
      return Order.none unless @start_date.present? && @end_date.present?

      payment_method_id = PaymentMethod.where("code ilike 'IPAY%'").pluck(:id)

      Order
      .select("orders.organization_id, (sum(case when (fees.code not ilike 'IPAY%' and fees.code not ilike 'INSURANCE%') then (order_items.amount) else 0 end) + (sum(case when (oi_ip.is_collection = true) then oi_ip.total_premium else 0 end))) as amount, sum(case when fees.code ilike 'IPAY%' then order_items.amount else 0 end) as process_fee, orders.paid_at::date as created_at")
      .joins(:latest_ipay88_request, :order_items)
      .joins('JOIN fees on order_items.fee_id = fees.id')
      .joins('LEFT JOIN insurance_purchases oi_ip on order_items.id = oi_ip.order_item_id')
      .where(:payment_method_id => payment_method_id, :status => 'PAID')
      .where('paid_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
      .where.not(ipay88_requests: {sync_date: nil})
      .search_organization(@branch_id)
      .group('orders.paid_at::date, orders.organization_id')
      .order('orders.paid_at::date ASC')
    end

    def set_swipes
      return Order.none unless @start_date.present? && @end_date.present?

      payment_method_id = PaymentMethod.where("code ilike 'SWIPE%'").pluck(:id)

      Order
      .select("orders.organization_id, (sum(case when (fees.code not ilike 'SWIPE%' and fees.code not ilike 'INSURANCE%') then (order_items.amount) else 0 end) + (sum(case when (oi_ip.is_collection = true) then oi_ip.total_premium else 0 end))) as amount, sum(case when fees.code ilike 'SWIPE%' then order_items.amount else 0 end) as process_fee, orders.paid_at::date as created_at")
      .joins(:latest_swipe_request, :order_items)
      .joins('JOIN fees on order_items.fee_id = fees.id')
      .joins('LEFT JOIN insurance_purchases oi_ip on order_items.id = oi_ip.order_item_id')
      .where(:payment_method_id => payment_method_id, :status => 'PAID')
      .where('paid_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
      .where.not(swipe_requests: {sync_date: nil})
      .search_organization(@branch_id)
      .group('orders.paid_at::date, orders.organization_id')
      .order('orders.paid_at::date ASC')
    end

    def set_fpxs
      return Order.none unless @start_date.present? && @end_date.present?

      payment_method_id = PaymentMethod.where("code ilike 'PAYNET%'").pluck(:id)

      Order
      .select("orders.organization_id, sum(case when fees.code not ilike 'PAYNET%' then order_items.amount else 0 end) as amount, sum(case when fees.code ilike 'PAYNET%' then order_items.amount else 0 end) as process_fee, orders.paid_at::date as created_at")
      .joins(:latest_fpx_request, :order_items)
      .joins('JOIN fees on order_items.fee_id = fees.id')
      .where(:payment_method_id => payment_method_id, :status => 'PAID')
      .where('paid_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
      .where.not(fpx_requests: {sync_date: nil})
      .search_organization(@branch_id)
      .group('orders.paid_at::date, orders.organization_id')
      .order('orders.paid_at::date ASC')
    end

    def set_bolehs
      return Order.none unless @start_date.present? && @end_date.present?

      payment_method_id = PaymentMethod.where("code ilike 'BOLEH%'").pluck(:id)

      Order
      .select("orders.organization_id, sum(case when fees.code not ilike 'BOLEH%' then order_items.amount else 0 end) as amount, sum(case when fees.code ilike 'BOLEH%' then order_items.amount else 0 end) as process_fee, orders.paid_at::date as created_at")
      .joins(:latest_boleh_request, :order_items)
      .joins('JOIN fees on order_items.fee_id = fees.id')
      .joins('LEFT JOIN insurance_purchases oi_ip on order_items.id = oi_ip.order_item_id')
      .where(:payment_method_id => payment_method_id, :status => 'PAID')
      .where('paid_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
      .where.not(boleh_requests: {sync_date: nil})
      .search_organization(@branch_id)
      .group('orders.paid_at::date, orders.organization_id')
      .order('orders.paid_at::date ASC')
    end

    def ipay_grouping
      @ipays_grouping ||=
        ipays
        .map { |ipay| ipay_mapping(ipay) }
        .group_by { |data| data[1] }
    end

    def swipe_grouping
      @swipes_grouping ||=
        swipes
        .map { |swipe| swipe_mapping(swipe) }
        .group_by { |data| data[1] }
    end

    def fpx_grouping
      @fpxs_grouping ||=
        fpxs
        .map { |fpx| fpx_mapping(fpx) }
        .group_by { |data| data[1] }
    end

    def boleh_grouping
      @bolehs_grouping ||=
        bolehs
        .map { |boleh| boleh_mapping(boleh) }
        .group_by { |data| data[1] }
    end

    def ipay_mapping(ipay)
      net_amount = ipay.amount
      gst_amount = 0
      processing_fee = ipay.process_fee
      draft_amount = ipay.amount+ipay.process_fee
      [
        ipay.created_at.try(:strftime, '%d/%m/%Y'),
        Organization.find(ipay.organization_id).try(:name),
        net_amount,
        gst_amount,
        processing_fee,
        draft_amount
      ]
    end

    def swipe_mapping(swipe)
      net_amount = swipe.amount
      gst_amount = 0
      processing_fee = swipe.process_fee
      draft_amount = swipe.amount+swipe.process_fee
      [
        swipe.created_at.try(:strftime, '%d/%m/%Y'),
        Organization.find(swipe.organization_id).try(:name),
        net_amount,
        gst_amount,
        processing_fee,
        draft_amount
      ]
    end

    def fpx_mapping(fpx)
      net_amount = fpx.amount
      gst_amount = 0
      processing_fee = fpx.process_fee
      draft_amount = fpx.amount+fpx.process_fee
      [
        fpx.created_at.try(:strftime, '%d/%m/%Y'),
        Organization.find(fpx.organization_id).try(:name),
        net_amount,
        gst_amount,
        processing_fee,
        draft_amount
      ]
    end

    def boleh_mapping(boleh)
      net_amount = boleh.amount
      gst_amount = 0
      processing_fee = boleh.process_fee
      draft_amount = boleh.amount+boleh.process_fee
      [
        boleh.created_at.try(:strftime, '%d/%m/%Y'),
        Organization.find(boleh.organization_id).try(:name),
        net_amount,
        gst_amount,
        processing_fee,
        draft_amount
      ]
    end

    def merged_data
      bank_draft_grouping.then do |registration_count_hash|
        registration_count_hash
        .merge(order_payment_grouping) { |_, old, new| old.concat new }
        .merge(voided_order_payment_grouping) { |_, old, new| old.concat new }
        .merge(voided_bank_draft_grouping) { |_, old, new| old.concat new }
        .merge(ipay_grouping) { |_, old, new| old.concat new }
        .merge(swipe_grouping) { |_, old, new| old.concat new }
        .merge(fpx_grouping) { |_, old, new| old.concat new }
        .merge(boleh_grouping) { |_, old, new| old.concat new }
      end
      .transform_values{|array| array.group_by{|a| [a[0], a[1]]}.map{|key, value|
        key + [value.inject(0){ |sum, i| sum+i[2] }, value.inject(0){ |sum, i| sum+i[3] },value.inject(0){ |sum, i| sum+i[4] },value.inject(0){ |sum, i| sum+i[5] } ]
        }
      }
      .sort_by { |h| h[0] }
    end
  end
end
