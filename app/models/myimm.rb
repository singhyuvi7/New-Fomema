class Myimm < ApplicationRecord
    audited
    include CaptureAuthor

    after_create :update_batch_code

    def update_batch_code
        batch_code = self.id
        self.update({
			batch_code: batch_code
		})
    end
end
