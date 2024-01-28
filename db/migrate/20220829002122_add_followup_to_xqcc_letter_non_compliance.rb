class AddFollowupToXqccLetterNonCompliance < ActiveRecord::Migration[6.0]
  def change
    add_column :xqcc_letter_non_compliances, :follow_up_with, :string
    add_column :xqcc_letter_non_compliances, :follow_up_date, :datetime
  end
end
