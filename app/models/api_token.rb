class ApiToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true

  enum :status, %i[live expired]
end
