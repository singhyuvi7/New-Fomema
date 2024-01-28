class Nios::NiosBase < ApplicationRecord
  self.abstract_class = true
  # connects_to database: { writing: :nios_migration }
end
