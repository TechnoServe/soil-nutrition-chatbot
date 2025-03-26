class CropProduction < ApplicationRecord
  include CmAdmin::CropProduction

  belongs_to :crop, class_name: 'Constant'
  belongs_to :desired_productivity, class_name: 'Constant'

  validates :crop, uniqueness: { scope: :desired_productivity }
  validates :productivity, presence: true

  delegate :name, to: :crop, prefix: true, allow_nil: true
  delegate :name, to: :desired_productivity, prefix: true, allow_nil: true
end
