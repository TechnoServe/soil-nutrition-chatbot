class CropNutrientDemand < ApplicationRecord
  include CmAdmin::CropNutrientDemand

  belongs_to :crop, class_name: 'Constant'
  belongs_to :nutrient, class_name: 'Constant'

  validates :value, presence: true
  validates :crop, uniqueness: { scope: :nutrient }

  delegate :name, to: :crop, prefix: true, allow_nil: true
  delegate :name, to: :nutrient, prefix: true, allow_nil: true
end
