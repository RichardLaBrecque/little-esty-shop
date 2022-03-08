class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :discount_rate, presence: true
  validates :threshold, presence: true
  validates :merchant_id, presence: true
  validates :discount_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
