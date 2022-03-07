class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant



  enum status: {"pending" => 0, "packaged" => 1, "shipped" => 2}

  validates_presence_of :quantity
  validates_presence_of :unit_price
  validates_presence_of :status

  def best_bulk_discount
    wip =  bulk_discounts.where('bulk_discounts.threshold <= ?', quantity)
                  .select('bulk_discounts.*')
                  .order(discount_rate: :desc)
                  .first
                  
  end

  def applied_bulk_discount
    if best_bulk_discount != nil
    (quantity * unit_price) - ((best_bulk_discount.discount_rate * 0.01) * (quantity * unit_price))
    else
      quantity * unit_price
    end
  end
end
