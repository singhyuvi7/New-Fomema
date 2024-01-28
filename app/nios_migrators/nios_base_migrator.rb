class NiosBaseMigrator

  def get_transaction(transaction_code)
    transaction = Transaction.where(code: transaction_code).first
  end

  def get_user(code)
    user = User.where(code: code).first
  end

  # get the nios user based on creator_id etc
  def get_nios_user(user_id)
    user = Nios::UserMaster.where(uuid: user_id).first
  end

  def get_parameter_value(value)

    return 'YES' if value == 'Y'

    return 'NO' if value == 'N'

    return value

  end

end