# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category).with_foreign_key(:category_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:category_id) }

    it { is_expected.to validate_presence_of(:default_price) }
    it { is_expected.to validate_numericality_of(:default_price).greater_than(0) }

    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:quantity).to_allow(only_integer: true) }
  end
end
