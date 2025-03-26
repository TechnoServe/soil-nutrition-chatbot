class CropNutrientRequirement < ApplicationRecord
  include CmAdmin::CropNutrientRequirement

  belongs_to :crop, class_name: 'Constant'
  belongs_to :nutrient, class_name: 'Constant'
  belongs_to :unit, class_name: 'Constant'

  validates :crop, uniqueness: { scope: :nutrient }

  delegate :name, to: :crop, prefix: true, allow_nil: true
  delegate :name, to: :nutrient, prefix: true, allow_nil: true
  delegate :name, to: :unit, prefix: true, allow_nil: true

  (1..6).to_a.each do |i|
    define_method "stage#{i}_value" do
      "#{send("stage#{i}")} (#{crop.stages[i - 1]})"
    end
  end
end
