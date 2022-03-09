class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  enum status: {"disabled" => 0, "enabled" => 1}

  validates_presence_of(:name)
  validates_presence_of(:status)

  def unique_invoices
    invoices.distinct
  end

  def ship_ready_items
    invoice_items.joins(:invoice)
                  .where.not(status: 2)
                  .order('invoices.created_at')
  end

  def top_five_customers
    customers.joins(invoices: :transactions)
             .where(transactions:{result: 1})
             .select("customers.*, COUNT(transactions.*) AS trans_count")
             .group("customers.id")
             .order(trans_count: :desc)
             .limit(5)
  end

   def top_five_items
     items.joins(invoice_items: {invoice: :transactions})
         .where(transactions:{result: 1})
         .select("items.*, SUM( invoice_items.unit_price * invoice_items.quantity)  AS totalrevenue")
         .group("items.id")
         .order(totalrevenue: :desc)
         .limit(5)
   end

   def self.top_five_merchants
     joins(items: {invoices: :transactions})
     .where(transactions: {result: 1})
     .select("merchants.*, SUM( invoice_items.unit_price * invoice_items.quantity) AS totalrevenue")
     .group(:id)
     .order(totalrevenue: :desc)
     .limit(5)
   end

   def best_sales_day
     invoices.joins(:invoice_items, :transactions)
             .where(transactions:{result: 1})
             .select("invoices.created_at, SUM( invoice_items.unit_price * invoice_items.quantity)  AS totalrevenue")
             .group("invoices.created_at")
             .order(totalrevenue: :desc)
             .first.created_at
   end

   def total_invoice_revenue(invoice_id)
     wip = invoice_items.where("invoice_items.invoice_id = ?", invoice_id)
                    .select("SUM(invoice_items.quantity * invoice_items.unit_price) AS total")
                    .group("invoice_items.id")
                    .sum(&:total)

   end

   def total_discounted_revenue(invoice_id)

      wip = invoice_items.joins(:bulk_discounts)
         .where('invoice_items.quantity >= bulk_discounts.threshold AND invoice_items.invoice_id = ?', invoice_id)
         .select('invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.discount_rate / 100.0)) as total_discount')
         .group('invoice_items.id')
         .sum(&:total_discount)

   end
end
