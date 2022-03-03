require 'rails_helper'

#   Merchant Bulk Discounts Index
#
# As a merchant
# When I visit my merchant dashboard
# Then I see a link to view all my discounts
# When I click this link
# Then I am taken to my bulk discounts index page
# Where I see all of my bulk discounts including their
# percentage discount and quantity thresholds
# And each bulk discount listed includes a link to its show page
RSpec.describe 'The Bulk Discount Index' do
  before (:each) do
    @merchant_1 = Merchant.create!(name: "Staples")
    @merchant_2 = Merchant.create!(name: "Home Depot")

    @item_1 = @merchant_1.items.create!(name: "stapler", description: "Staples papers together", unit_price: 13)
    @item_2 = @merchant_1.items.create!(name: "paper", description: "construction", unit_price: 29)
    @item_3 = @merchant_1.items.create!(name: "calculator", description: "TI-84", unit_price: 84)
    @item_4 = @merchant_2.items.create!(name: "paperclips", description: "24 Count", unit_price: 25)

    @customer_1 = Customer.create!(first_name: "Person 1", last_name: "Mcperson 1")
    @customer_2 = Customer.create!(first_name: "Person 2", last_name: "Mcperson 2")
    @customer_3 = Customer.create!(first_name: "Person 3", last_name: "Mcperson 3")
    @customer_4 = Customer.create!(first_name: "Person 4", last_name: "Mcperson 4")
    @customer_5 = Customer.create!(first_name: "Person 5", last_name: "Mcperson 5")
    @customer_6 = Customer.create!(first_name: "Person 6", last_name: "Mcperson 6")

    @invoice_1 = @customer_1.invoices.create!(status: "completed")
    @invoice_2 = @customer_1.invoices.create!(status: "cancelled")
    @invoice_3 = @customer_2.invoices.create!(status: "in progress")
    @invoice_4 = @customer_2.invoices.create!(status: "completed")
    @invoice_5 = @customer_2.invoices.create!(status: "cancelled")
    @invoice_6 = @customer_3.invoices.create!(status: "in progress")
    @invoice_7  = @customer_3.invoices.create!(status: "completed")
    @invoice_8 = @customer_3.invoices.create!(status: "cancelled")
    @invoice_9 = @customer_4.invoices.create!(status: "in progress")
    @invoice_10 = @customer_4.invoices.create!(status: "completed")
    @invoice_11 = @customer_5.invoices.create!(status: "cancelled")
    @invoice_12 = @customer_6.invoices.create!(status: "in progress")

    @invoice_item_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 13, status: "shipped")
    @invoice_item_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_2.id, quantity: 2, unit_price: 29, status: "packaged")
    @invoice_item_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, quantity: 3, unit_price: 84, status: "pending")
    @invoice_item_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_4.id, quantity: 4, unit_price: 25, status: "shipped")
    @invoice_item_5 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_1.id, quantity: 5, unit_price: 13, status: "packaged")
    @invoice_item_6 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_2.id, quantity: 6, unit_price: 29, status: "pending")
    @invoice_item_7 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_3.id, quantity: 1, unit_price: 84, status: "shipped")
    @invoice_item_8 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 2, unit_price: 25, status: "packaged")
    @invoice_item_9 = InvoiceItem.create!(invoice_id: @invoice_9.id, item_id: @item_1.id, quantity: 3, unit_price: 13, status: "pending")
    @invoice_item_10 = InvoiceItem.create!(invoice_id: @invoice_10.id, item_id: @item_2.id, quantity: 4, unit_price: 29, status: "shipped")
    @invoice_item_11 = InvoiceItem.create!(invoice_id: @invoice_11.id, item_id: @item_3.id, quantity: 5, unit_price: 84, status: "packaged")
    @invoice_item_12 = InvoiceItem.create!(invoice_id: @invoice_12.id, item_id: @item_4.id, quantity: 6, unit_price: 25, status: "pending")

    @transcation_1 = @invoice_1.transactions.create!(credit_card_number: "4654405418249632", result: "success")
    @transcation_2 = @invoice_2.transactions.create!(credit_card_number: "4654405418249634", result: "success")
    @transcation_3 = @invoice_3.transactions.create!(credit_card_number: "4654405418249635", result: "success")
    @transcation_4 = @invoice_4.transactions.create!(credit_card_number: "4654405418249636", result: "success")
    @transcation_5 = @invoice_5.transactions.create!(credit_card_number: "4654405418249637", result: "success")
    @transcation_6 = @invoice_6.transactions.create!(credit_card_number: "4654405418249638", result: "success")
    @transcation_7 = @invoice_7.transactions.create!(credit_card_number: "4654405418249639", result: "success")
    @transcation_8 = @invoice_8.transactions.create!(credit_card_number: "4654405418249630", result: "success")
    @transcation_9 = @invoice_9.transactions.create!(credit_card_number: "4654405418249612", result: "success")
    @transcation_10 = @invoice_10.transactions.create!(credit_card_number: "4654405418249613", result: "success")
    @transcation_11 = @invoice_11.transactions.create!(credit_card_number: "4654405418249614", result: "success")
    @transcation_12 = @invoice_12.transactions.create!(credit_card_number: "4654405418249635", result: "failed")

    @discount_1 = @merchant_1.bulk_discounts.create!(discount_rate: 10, threshold: 2)
    @discount_2 = @merchant_1.bulk_discounts.create!(discount_rate: 25, threshold: 4)
  end
  it 'has a link on the merchant dashboard' do
    visit "/merchants/#{@merchant_1.id}/dashboard"
    expect(page).to have_link("View Bulk Discounts")
    click_on("View Bulk Discounts")
    expect(current_path).to eq("/merchants/#{@merchant_1.id}/bulk_discounts")
  end

  it 'lists all bulk discounts, the thresholds, and discounts rates' do
    visit "/merchants/#{@merchant_1.id}/bulk_discounts"
    within "discounts"
    save_and_open_page
    expect(page).to have_content("Discount Rate:#{@discount_1.discount_rate}")
    expect(page).to have_content("Discount Threshold:#{@discount_1.threshold}")
    expect(page).to have_link("Discount: 1")

    expect(page).to have_content("Discount Rate:#{@discount_2.discount_rate}")
    expect(page).to have_content("Discount Threshold:#{@discount_2.threshold}")
    expect(page).to have_link("Discount: 2")
  end
end
