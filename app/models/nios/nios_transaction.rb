class Nios::NiosTransaction < Nios::NiosBase
  self.table_name = "nios_foreign.fw_transaction"
  self.primary_key = "trans_id"
end