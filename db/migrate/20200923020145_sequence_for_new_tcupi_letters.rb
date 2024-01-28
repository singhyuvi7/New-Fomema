class SequenceForNewTcupiLetters < ActiveRecord::Migration[6.0]
    def change
        sql = "create sequence tcupi_letter_seq
        increment 1
        minvalue 1
        maxvalue 999999999999
        cycle
        start with 1"
        execute sql
    end
end