# frozen_string_literal: true

class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :default_price, type: BigDecimal
  field :quantity, type: Integer

  belongs_to :category, optional: false

  validates :name, presence: true, uniqueness: { scope: :category_id }
  validates :default_price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
