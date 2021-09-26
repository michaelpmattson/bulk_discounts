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
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_content("Status: #{@invoice_1.status}")
      expect(page).to have_content("Created on: #{@invoice_1.formatted_date}")
      expect(page).to have_content("Customer: #{@customer_1.first_name} #{@customer_1.last_name}")
    end

    it 'shows all of my items on the invoice' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@invoice_item_1.quantity)
      expect(page).to have_content(@invoice_item_1.unit_price)
      expect(page).to have_content(@invoice_item_1.status)
      expect(page).to_not have_content(@item_4.name)
    end
  end

  context 'total revenue' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1     = create(:item, merchant: @merchant_1)
      @item_2     = create(:item, merchant: @merchant_1)
      @item_3     = create(:item, merchant: @merchant_1)
      @item_4     = create(:item, merchant: @merchant_1)

      @merchant_2 = create(:merchant)
      @item_5     = create(:item, merchant: @merchant_2)
      @item_6     = create(:item, merchant: @merchant_2)

      @invoice_1  = create(:invoice)
      @ii11       = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 1, unit_price: 10)
      @ii12       = create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 2, unit_price: 6)
      @ii13       = create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 3, unit_price: 5)

      @invoice_2  = create(:invoice)
      @ii24       = create(:invoice_item, invoice: @invoice_2, item: @item_4, quantity: 1, unit_price: 10)
      @ii26       = create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 2, unit_price: 6)
      @ii26       = create(:invoice_item, invoice: @invoice_2, item: @item_6, quantity: 3, unit_price: 5)

      @transaction_fail_1 = create(:transaction, invoice: @invoice_1)
      @transaction_1      = create(:transaction, invoice: @invoice_1, result: 'success')
      @transaction_2      = create(:transaction, invoice: @invoice_2, result: 'success')
    end

    it 'displays total revenue for invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1.id)
      expect(page).to have_content("Total Revenue: $37.00")
    end

    it 'does not add revenue for other merchants' do
      visit merchant_invoice_path(@merchant_1, @invoice_2.id)
      expect(page).to have_content("Total Revenue: $10.00")
    end
  end

  context 'bulk discounts' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1     = create(:item, merchant: @merchant_1)
      @item_2     = create(:item, merchant: @merchant_1)
      @item_3     = create(:item, merchant: @merchant_1)
      @item_4     = create(:item, merchant: @merchant_1)

      @discount_1 = create(:bulk_discount, merchant: @merchant_1, percentage: 10, quantity_threshold: 2)

      @merchant_2 = create(:merchant)
      @item_5     = create(:item, merchant: @merchant_2)
      @item_6     = create(:item, merchant: @merchant_2)

      @invoice_1  = create(:invoice)
      @ii11       = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 1, unit_price: 10)
      @ii12       = create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 2, unit_price: 6)
      @ii13       = create(:invoice_item, invoice: @invoice_1, item: @item_3, quantity: 3, unit_price: 5)

      @invoice_2  = create(:invoice)
      @ii24       = create(:invoice_item, invoice: @invoice_2, item: @item_4, quantity: 1, unit_price: 10)
      @ii26       = create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 2, unit_price: 6)
      @ii26       = create(:invoice_item, invoice: @invoice_2, item: @item_6, quantity: 3, unit_price: 5)

      @transaction_1      = create(:transaction, invoice: @invoice_1, result: 'success')
      @transaction_2      = create(:transaction, invoice: @invoice_2, result: 'success')
    end

    it 'displays total revenue for invoice' do
      visit merchant_invoice_path(@merchant_1, @invoice_1.id)
      expect(page).to have_content("Total Revenue: $37.00")
    end

    it 'displays total discounted revenue' do
      visit merchant_invoice_path(@merchant_1, @invoice_1.id)
      expect(page).to have_content("Total Discounted Revenue: $34.30")
    end

    it 'has a link for each discount applied' do
      visit merchant_invoice_path(@merchant_1, @invoice_1.id)
      save_and_open_page
      within "#item-#{@item_2.id}" do
        click_link('View Discount')
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))

      visit merchant_invoice_path(@merchant_1, @invoice_1.id)
      within "#item-#{@item_3.id}" do
        click_link('View Discount')
      end
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @discount_1))
    end
  end
end


# As a merchant
# When I visit my merchant invoice show page
# Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
