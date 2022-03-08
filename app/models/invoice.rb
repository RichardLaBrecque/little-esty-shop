class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: {"cancelled" => 0, "in progress" => 1, "completed" => 2}

  validates_presence_of :status

  def total_invoice_revenue
    invoice_items.sum("unit_price * quantity")
    binding.pry
  end

  def self.not_completed
    where(:invoices => {status: 1}).order(created_at: :asc)
  end

  def discounted_price
      invoice_items.sum do |invoice_item|
       invoice_item.applied_bulk_discount
      end
    # wip = invoice_items.left_joins(:bulk_discounts)
    # .where("invoice_items.quantity >= bulk_discounts.threshold")
    # .select("invoice_items.*, MAX(bulk_discounts.discount_rate) AS discount")
    # .group("invoice_items.id, items.id")
    # .order(discount: :desc)
# SELECT invoice_items.*, MAX(bulk_discounts.discount_rate) AS discount
# FROM invoice_items
# LEFT OUTER JOIN items ON items.id = invoice_items.item_id
# LEFT OUTER JOIN merchants ON merchants.id = items.merchant_id
# LEFT OUTER JOIN bulk_discounts ON bulk_discounts.merchant_id = merchants.id
# WHERE invoice_items.invoice_id = 45
# AND bulk_discounts.threshold <= invoice_items.quantity
# GROUP BY invoice_items.id, items.id
# ORDER BY discount desc

  end
end
