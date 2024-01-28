class AddBankDraftAllocationsAllocateable < ActiveRecord::Migration[6.0]
  def change
    add_column :bank_draft_allocations, :allocatable_type, :string
    add_column :bank_draft_allocations, :allocatable_id, :bigint

    ActiveRecord::Base.connection.execute("update bank_draft_allocations set allocatable_id = order_id, allocatable_type = 'Order'")

    remove_column :bank_draft_allocations, :order_id, :bigint
    add_index :bank_draft_allocations, [:allocatable_id, :allocatable_type], name: "index_bank_draft_allocationson_allocatable"
  end
end
