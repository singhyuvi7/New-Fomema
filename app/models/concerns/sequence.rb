module Sequence
  extend ActiveSupport::Concern

  included do
      def seq_nextval(seq_name)
      ActiveRecord::Base.connection.execute("SELECT nextval('#{seq_name}')")[0]["nextval"]
      end

      def seq_currval(seq_name)
          ActiveRecord::Base.connection.execute("SELECT currval('#{seq_name}')")[0]["currval"]
      end

      def get_or_create_sequence(sequence_name)
          rs = ActiveRecord::Base.connection.execute("SELECT count(*) FROM information_schema.sequences where sequence_name = '#{sequence_name}'")
          if rs.first["count"] == 0
              sql = "create sequence #{sequence_name} 
              increment 1 
              cycle 
              start with 1"
              ActiveRecord::Base.connection.execute sql
          end
          seq_nextval(sequence_name)
      end
  end
end