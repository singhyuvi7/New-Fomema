class CreateAllSequence < ActiveRecord::Migration[5.2]
  def up
    seq_count = 0
    State.pluck(:code).each do |state|
      ["e", "w", "d", "x", "l", "r"].each do |prefix|
        state = state.downcase
        ('a'..'z').each do |name|
          seq_name = "code_#{prefix}#{state}#{name}_seq".downcase
          puts seq_name
          sql = "create sequence #{seq_name}
          increment 1
          minvalue 1
          maxvalue 999999
          cycle
          start with 1"
          execute sql
          seq_count = seq_count + 1
        end
        ('0'..'9').each do |name|
          seq_name = "code_#{prefix}#{state}#{name}_seq".downcase
          puts seq_name
          sql = "create sequence #{seq_name}
          increment 1
          minvalue 1
          maxvalue 999999
          cycle
          start with 1"
          execute sql
          seq_count = seq_count + 1
        end
      end
    end
    puts "#{seq_count} sequence generated"

    sql = "create sequence code_transaction_seq
    increment 1
    minvalue 500000
    maxvalue 999999
    cycle
    start with 500000"
    execute sql

    sql = "create sequence iqa_seq
    increment 1
    cycle"
    execute sql

    sql = "create sequence sp_group_doctor_seq
    increment 1
    cycle"
    execute sql

    sql = "create sequence sp_group_laboratory_seq
    increment 1
    cycle"
    execute sql

    sql = "create sequence sp_group_xray_facility_seq
    increment 1
    cycle"
    execute sql

    sql = "create sequence retake_xray_seq
    increment 1
    minvalue 1
    maxvalue 999999999999
    cycle
    start with 1"
    execute sql

    # Need to remove the file sequence_for_medical_appeal when dropping this db.
    # sql = "create sequence medical_appeal_seq
    # increment 1
    # minvalue 1
    # maxvalue 999999999999
    # cycle
    # start with 1"
    # execute sql
  end

  def down
    State.pluck(:code).each do |state|
      ["e", "w", "d", "x", "l", "r"].each do |prefix|
        state = state.downcase
        ('a'..'z').each do |name|
          seq_name = "code_#{prefix}#{state}#{name}_seq".downcase
          sql = "drop sequence #{seq_name}"
          execute sql
        end
        ('0'..'9').each do |name|
          seq_name = "code_#{prefix}#{state}#{name}_seq".downcase
          sql = "drop sequence #{seq_name}"
          execute sql
        end
      end
    end

    ["code_transaction", "iqa"].each do |name|
      sql = "drop sequence #{name}_seq"
      execute sql
    end
  end
end
