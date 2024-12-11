# frozen_string_literal: true

class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  has_many :products, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
