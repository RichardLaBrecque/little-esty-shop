class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.integer :discount_rate
      t.integer :threshold
      t.references :merchant, foreign_key: true
      t.timestamps
    end
  end
end
