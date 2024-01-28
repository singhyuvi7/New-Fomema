class SignUp < ApplicationRecord
  belongs_to :sign_upable, polymorphic: true, optional: true

  acts_as_approval_user
end
