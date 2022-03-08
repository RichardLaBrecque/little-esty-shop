require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'relationships' do
    it {should belong_to :merchant}
  end

  describe 'validations' do
    it { should validate_presence_of(:discount_rate) }
    it { should validate_presence_of(:threshold) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_numericality_of(:discount_rate).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:discount_rate).is_less_than_or_equal_to(100) }
  end
end
