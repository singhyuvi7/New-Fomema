class AddFailReasonToRefunds < ActiveRecord::Migration[6.0]
  def change
    add_column :refunds, :fail_reason, :text
  end
end
