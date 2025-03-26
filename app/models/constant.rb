class Constant < ApplicationRecord
  CONSTANT_TYPES = %w[crop desired_productivity state nutrient organic_matter unit amendment age_range gender].freeze
  include CmAdmin::Constant

  enum :constant_type, CONSTANT_TYPES

  belongs_to :parent, class_name: 'Constant', optional: true
  has_many :children, class_name: 'Constant', foreign_key: 'parent_id'
  has_many :constant_translations, dependent: :destroy

  delegate :name, to: :parent, prefix: true, allow_nil: true

  store_accessor :meta, :carbon_content, :stages

  def display_name
    name
  end

  def spanish_translation
    constant_translations.find_by(locale: 'es')
  end
end
