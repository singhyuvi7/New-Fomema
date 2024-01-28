class DoctorExaminationVisited < ApplicationRecord
    audited
    acts_as_paranoid
    include CaptureAuthor

    belongs_to :doctor_examination, inverse_of: :doctor_examination_visited, optional: true
end