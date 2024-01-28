# frozen_string_literal: true

module FinanceHelper
  def grand_total_calculation(grand_total, data)
    _, title, male_count, female_count, = data

    selector = title.parameterize(separator: '_').to_sym
    grand_total[selector][:male] += male_count
    grand_total[selector][:female] += female_count
  end
end
