class CreateOrderAndRefundView < ActiveRecord::Migration[6.0]
    def change
        execute "drop view if exists v_orders_order_items"
        
        execute "create or replace view v_orders_order_items as
        select orders.id order_id, order_items.id order_item_id, orders.payment_method_id, order_items.fee_id,
        orders.code order_code, orders.date order_date, 
        orders.customerable_id, orders.customerable_type, orders.category order_category, orders.amount order_amount, orders.status order_status, orders.paid_at order_paid_at, 
        payment_methods.code payment_method_code, 
        order_items.order_itemable_id, order_items.order_itemable_type, order_items.amount order_item_amount, order_items.gender order_item_gender,
        fees.code fee_code, fees.amount fee_amount
        from orders left join order_items on order_items.order_id = orders.id
        left join payment_methods on orders.payment_method_id = payment_methods.id
        left join fees on order_items.fee_id = fees.id"

        execute "drop view if exists v_refunds_refund_items"

        execute "create or replace view v_refunds_refund_items as
        select refunds.id refund_id, refund_items.id refund_item_id, 
        refunds.customerable_id, refunds.customerable_type, refunds.category, refunds.date refund_date, refunds.amount refund_amount, refunds.status refund_status,
        payment_methods.code payment_method_code,
        refund_items.refund_itemable_id, refund_items.refund_itemable_type, refund_items.amount refund_item_amount
        from refunds left join refund_items on refund_items.refund_id = refunds.id
        left join payment_methods on refunds.payment_method_id = payment_methods.id"
    end
end
