class ConstantTranslation < ApplicationRecord
  belongs_to :constant

  store_accessor :meta, :carbon_content, :stages
end
