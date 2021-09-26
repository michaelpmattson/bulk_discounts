require 'rails_helper'

RSpec.describe 'admin invoices show page', type: :feature do
  describe 'no discounts' do
    before(:each) do
      @item_1 = create(:item)
      @item_2 = create(:item, name: "Hi-Chew")
      @item_3 = create(:item, name: "edible rhinestones")
      @item_4 = create(:item, name: "catnip")
      @item_5 = create(:item, name: "pens")
      @item_6 = create(:item, name: "vinyl record")

      @invoice_1 = create(:invoice, created_at: '2012-03-25 09:54:09 UTC', status: 1) # Sunday, March 25,2012
      @transaction_1 = create(:transaction, result: 'success')
      @invoice_1.transactions << @transaction_1
      @invoice_1_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 1)
      @invoice_1_item_2 = create(:invoice_item, item: @item_2, quantity: 2, unit_price: 6, status: 2)
      @invoice_1_item_6 = create(:invoice_item, item: @item_6, quantity: 1, unit_price: 5, status: 3)
      @invoice_1.invoice_items << @invoice_1_item_1
      @invoice_1.invoice_items << @invoice_1_item_2
      @invoice_1.invoice_items << @invoice_1_item_6

      @invoice_2 = create(:invoice, created_at: '2012-03-24 15:54:10 UTC') # Saturday, March 25, 2012
      @transaction_2 = create(:transaction)
      @invoice_2.transactions << @transaction_2
      @invoice_2_item_3 = create(:invoice_item, item: @item_3, quantity: 4, unit_price: 4, status: 2)
      @invoice_2_item_4 = create(:invoice_item, item: @item_4, quantity: 5, unit_price: 3, status: 2)
      @invoice_2_item_6 = create(:invoice_item, item: @item_6, quantity: 6, unit_price: 2, status: 3)
      @invoice_2.invoice_items << @invoice_2_item_3
      @invoice_2.invoice_items << @invoice_2_item_4
      @invoice_2.invoice_items << @invoice_2_item_6

      @invoice_3 = create(:invoice, created_at: '2012-03-21 13:54:10 UTC') # Wednesday, March 21, 2012
      @transaction_3 = create(:transaction, result: 'success')
      @invoice_3.transactions << @transaction_3
      @invoice_3_item_5 = create(:invoice_item, item: @item_5, quantity: 7, unit_price: 1, status: 1)
      @invoice_3.invoice_items << @invoice_3_item_5
    end

    it 'displays invoice attributes' do
      visit admin_invoice_path(@invoice_1.id)
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_content("Created on: Sunday, March 25, 2012")
      expect(page).to have_content("Customer: #{@invoice_1.customer_name}")
    end

    it 'displays status and updates in drop down form' do
      visit admin_invoice_path(@invoice_1.id)
      expect(page).to have_field("invoice[status]", with: @invoice_1.status)
      select "completed", :from => 'invoice[status]'
      click_on "Update Invoice"
      expect(current_path).to eq(admin_invoice_path(@invoice_1.id))
      expect(page).to have_field('invoice[status]', with: 'completed')
    end

    it 'displays invoice items' do
      visit admin_invoice_path(@invoice_1.id)
      within('#items') do
        within("#items-#{@item_1.id}") do
          expect(page).to have_content(@item_1.name) #Item name
          expect(page).to have_content(@invoice_1_item_1.quantity)#The quantity of the item ordered
          expect(page).to have_content(@invoice_1_item_1.unit_price)#The price the Item sold for
          expect(page).to have_content(@invoice_1_item_1.status)#The Invoice Item status
        end
        within("#items-#{@item_2.id}") do
          expect(page).to have_content(@item_2.name) #Item name
          expect(page).to have_content(@invoice_1_item_2.quantity)#The quantity of the item ordered
          expect(page).to have_content(@invoice_1_item_2.unit_price)#The price the Item sold for
          expect(page).to have_content(@invoice_1_item_2.status)#The Invoice Item status
        end
        within("#items-#{@item_6.id}") do
          expect(page).to have_content(@item_6.name) #Item name
          expect(page).to have_content(@invoice_1_item_6.quantity)#The quantity of the item ordered
          expect(page).to have_content(@invoice_1_item_6.unit_price)#The price the Item sold for
          expect(page).to have_content(@invoice_1_item_6.status)#The Invoice Item status
        end
        expect(page).to_not have_content(@item_3.name)
        expect(page).to_not have_content(@item_4.name)
        expect(page).to_not have_content(@item_5.name)
      end
    end

    it 'displays total revenue for invoice' do
      visit admin_invoice_path(@invoice_1.id)
      expect(page).to have_content("$#{@invoice_1.total_revenue}")
      expect(page).to_not have_content("$#{@invoice_2.total_revenue}")
      expect(page).to_not have_content("$#{@invoice_3.total_revenue}")

      visit admin_invoice_path(@invoice_2.id)
      expect(page).to have_content("$#{@invoice_2.total_revenue}")
      expect(page).to_not have_content("$#{@invoice_3.total_revenue}")
      expect(page).to_not have_content("$#{@invoice_1.total_revenue}")

      visit admin_invoice_path(@invoice_3.id)
      expect(page).to have_content("$#{@invoice_3.total_revenue}")
      expect(page).to_not have_content("$#{@invoice_2.total_revenue}")
      expect(page).to_not have_content("$#{@invoice_1.total_revenue}")
    end
  end

  describe 'discounts' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1     = create(:item, merchant: @merchant_1)
      @item_2     = create(:item, merchant: @merchant_1)
      @item_3     = create(:item, merchant: @merchant_1)
      @item_4     = create(:item, merchant: @merchant_1)

      @discount_1 = create(:bulk_discount, merchant: @merchant_1, percentage: 10, quantity_threshold: 3)

      @merchant_2 = create(:merchant)
      @item_5     = create(:item, merchant: @merchant_2)
      @item_6     = create(:item, merchant: @merchant_2)

      @discount_2 = create(:bulk_discount, merchant: @merchant_1, percentage: 15, quantity_threshold: 5)

      @invoice_1  = create(:invoice)
      @ii11       = create(:invoice_item, invoice: @invoice_1, item: @item_1, quantity: 1, unit_price: 10)
      @ii12       = create(:invoice_item, invoice: @invoice_1, item: @item_2, quantity: 3, unit_price: 6)
      @ii15       = create(:invoice_item, invoice: @invoice_1, item: @item_5, quantity: 5, unit_price: 5)

      @invoice_2  = create(:invoice)
      @ii24       = create(:invoice_item, invoice: @invoice_2, item: @item_4, quantity: 10, unit_price: 10)
      @ii25       = create(:invoice_item, invoice: @invoice_2, item: @item_5, quantity: 3, unit_price: 6)
      @ii26       = create(:invoice_item, invoice: @invoice_2, item: @item_6, quantity: 5, unit_price: 5)

      @transaction_1      = create(:transaction, invoice: @invoice_1, result: 'success')
      @transaction_2      = create(:transaction, invoice: @invoice_2, result: 'success')
    end

    it 'displays total revenue for invoice' do
      visit admin_invoice_path(@invoice_1.id)
      expect(page).to have_content("Total Revenue: $53.00")

      visit admin_invoice_path(@invoice_2.id)
      expect(page).to have_content("Total Revenue: $143.00")
    end

    it 'displays total discounted revenue' do
      visit admin_invoice_path(@invoice_1.id)
      expect(page).to have_content("Total Discounted Revenue: $47.45")

      visit admin_invoice_path(@invoice_2.id)
      expect(page).to have_content("Total Discounted Revenue: $121.55")
    end
  end
end

# As an admin
# When I visit an admin invoice show page
# Then I see the total revenue from this invoice (not including discounts)
# And I see the total discounted revenue from this invoice which includes bulk discounts in the calculation
