class AddTypeToVisitPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_plans, :visit_type, :string
  end
end
