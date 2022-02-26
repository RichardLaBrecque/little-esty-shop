class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  enum status: {"cancelled" => 0, "in progress" => 1, "completed" => 2}

  validates_presence_of :status

  def total_revenue
    invoice_items.sum(:unit_price)
  end

  def total_invoice_revenue
    total = invoice_items.map do |invoice_item|
      invoice_item.quantity * invoice_item.unit_price
    end
    return total.sum
  end

end
