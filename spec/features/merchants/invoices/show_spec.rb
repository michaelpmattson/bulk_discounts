require 'rails_helper'

RSpec.describe 'Merchant Invoice Show Page' do
  context 'when i visit my merchant invoice show page' do
    before :each do
      @merchant_2 = create(:merchant)
      @item_4     = create(:item, merchant: @merchant_2, name: "watermelon")
      
      @merchant_1 = create(:merchant)
      @item_1     = create(:item, merchant: @merchant_1) # cookies
      @item_2     = create(:item, merchant: @merchant_1, name: "crackers", status: "Enabled")
      @item_3     = create(:item, merchant: @merchant_1, name: "biscuits")
      @item_5     = create(:item, merchant: @merchant_1, name: "wafers", status: "Enabled")
      @customer_1 = create(:customer)
      @customer_2 = create(:customer, first_name: "Betty", last_name: "Sue")
      @invoice_1 = create(:invoice, customer: @customer_1)
      @invoice_2 = create(:invoice, customer: @customer_1, status: 1)
      @invoice_3 = create(:invoice, customer: @customer_1, status: 2)
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id)
      @invoice_item_4 = create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_1.id)

      

      # create(:invoice_item, item: @item_1, invoice: @invoice_1)
      # create(:invoice_item, item: @item_4, invoice: @invoice_2)
      # create(:invoice_item, item: @item_3, invoice: @invoice_3)

      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}"
    end

    it 'shows relative info to invoices' do
      expect(page).to have_content("Invoice ID: #{@invoice_1.id}")
      expect(page).to have_content("Invoice Status: #{@invoice_1.status}")
      expect(page).to have_content("Invoice Created: #{@invoice_1.formatted_date}")
      expect(page).to have_content("Customer: #{@customer_1.first_name} #{@customer_1.last_name}")
    end

    it 'shows all of my items on the invoice' do
      expect(page).to have_content("Item Name: #{@item_1.name}")
      expect(page).to have_content("Item Quantity: #{@invoice_item_1.quantity}")
      expect(page).to have_content("Item Price: #{@invoice_item_1.unit_price}")
      expect(page).to have_content("Item Status: #{@invoice_item_1.status}")
      expect(page).to_not have_content("#{@item_4.name}")
    end
  end
end