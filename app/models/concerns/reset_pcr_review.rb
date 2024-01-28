module ResetPcrReview
  extend ActiveSupport::Concern

  included do

    def reset_pcr_review_cols

      pcr_review_cols = PcrReview.column_names

      reset_cols = {}
      except_cols = %w(id transaction_id case_type created_by updated_by pcr_id created_at updated_at transmitted_at poolable_type poolable_id is_legacy trans_id legacy_id )

      pcr_review_cols.each do |col|

        if except_cols.exclude?(col)
          reset_cols[col] = nil
        end

      end

      reset_cols
    end

  end

end