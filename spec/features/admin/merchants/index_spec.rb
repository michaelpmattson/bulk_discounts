require 'rails_helper'

RSpec.describe 'admin merchants index page', type: :feature do
  context 'visit page' do
    before(:each) do
      @merchant_1 = create(:merchant) #Sprouts
      @merchant_2 = create(:merchant, name: "Jennys Jewels", status: "Enabled")
      @merchant_3 = create(:merchant, name: "Strawberry Prints")

      visit "/admin/merchants"
    end

    it 'displays all merchant names' do
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_content(@merchant_1.name)
      end
      within("#merchant-#{@merchant_2.id}") do
        expect(page).to have_content(@merchant_2.name)
      end
      within("#merchant-#{@merchant_3.id}") do
        expect(page).to have_content(@merchant_3.name)
      end
    end

    it 'names link to show page' do
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_link(@merchant_1.name)
      end
      within("#merchant-#{@merchant_2.id}") do
        expect(page).to have_link(@merchant_2.name)
      end
      within("#merchant-#{@merchant_3.id}") do
        expect(page).to have_link(@merchant_3.name)
      end
      click_on "Jennys Jewels"

      expect(current_path).to eq("/admin/merchants/#{@merchant_2.id}")
    end

    it 'has disable button for enabled merchants' do
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to_not have_button('Disable')
      end
      within("#merchant-#{@merchant_2.id}") do
        expect(page).to have_button("Disable")
        click_on 'Disable'
      end
      within("#merchant-#{@merchant_2.id}") do
        expect(page).to_not have_button('Disable')
        expect(page).to have_button('Enable')
      end
    end

    it 'has enable button for disabled merchants' do
      within("#merchant-#{@merchant_1.id}") do
        expect(page).to have_button('Enable')
      end
      within("#merchant-#{@merchant_2.id}") do
        expect(page).to_not have_button("Enable")
      end
      within("#merchant-#{@merchant_3.id}") do
        expect(page).to have_button('Enable')
        click_on 'Enable'
      end
      within("#merchant-#{@merchant_3.id}") do
        expect(page).to_not have_button('Enable')
        expect(page).to have_button("Disable")
      end
    end

    it 'groups merchants by status' do
      within('#enabled') do
        expect(page).to have_content(@merchant_2.name)
        expect(page).to_not have_content(@merchant_1.name)
        expect(page).to_not have_content(@merchant_3.name)
      end
      within('#disabled') do
        expect(page).to_not have_content(@merchant_2.name)
        expect(page).to have_content(@merchant_1.name)
        expect(page).to have_content(@merchant_3.name)
      end
    end

    it 'has link to create new merchant' do
      expect(page).to have_link("New Merchant")

      click_on "New Merchant"
      expect(current_path).to eq(new_admin_merchant_path)
    end
  end
  context 'top five merchants' do
    before(:each) do
      @transaction_s = create(:transaction, result: 'success')
      @merchant_1 = create(:merchant)
      @enabled_item_1  = create(:item, merchant: @merchant_1, status: 'Enabled')
      @invoice_1 = create(:invoice, created_at: '2012-03-25 09:54:09 UTC') # Sunday, March 25,2012
      @invoice_1.transactions << @transaction_s
      @invoice_1_1 = create(:invoice)
      @transaction_s_1 = create(:transaction, result: 'success')
      @invoice_1_1.transactions << @transaction_s_1
      @i_i_1 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1_1)
      @i_i_2 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1)
      @i_i_3 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1)

      @merchant_2 = create(:merchant, name: "Jennys Jewels", status: 'Enabled')
      @item_2 = create(:item, merchant: @merchant_2)
      @invoice_2 = create(:invoice)
      @transaction_s_2 = create(:transaction, result: 'success')
      @invoice_2.transactions << @transaction_s_2
      @invoice_3 = create(:invoice, created_at: '2012-03-24 15:54:10 UTC') # Saturday, March 25, 2012
      @transaction_s_3 = create(:transaction, result: 'success')
      @invoice_3.transactions << @transaction_s_3
      @i_i_4 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_2)
      @i_i_5 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_3)
      @i_i_6 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_3)

      @merchant_3 = create(:merchant, name: "Super Sam", status: 'Enabled')
      @item_3 = create(:item, merchant: @merchant_3)
      @invoice_4 = create(:invoice)
      @transaction_s_4 = create(:transaction, result: 'success')
      @invoice_4.transactions << @transaction_s_4
      @invoice_5 = create(:invoice, created_at: '2012-03-21 13:54:10 UTC') # Wednesday, March 21, 2012
      @transaction_s_5 = create(:transaction, result: 'success')
      @invoice_5.transactions << @transaction_s_5
      @i_i_7 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_4)
      @i_i_8 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_5)
      @i_i_9 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_5)

      @merchant_4 = create(:merchant, name: "Random Rogers", status: 'Enabled')
      @item_4 = create(:item, merchant: @merchant_4)
      @invoice_6 = create(:invoice)
      @transaction_s_6 = create(:transaction, result: 'success')
      @invoice_6.transactions << @transaction_s_6
      @invoice_7 = create(:invoice, created_at: '2012-03-10 10:54:10 UTC') # Saturday, March 10, 2012
      @transaction_s_7 = create(:transaction, result: 'success')
      @invoice_7.transactions << @transaction_s_7
      @i_i_10 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_6)
      @i_i_11 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_7)
      @i_i_12 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_7)

      @merchant_5 = create(:merchant, name: "Caras Cupcakes", status: 'Enabled')
      @item_5 = create(:item, merchant: @merchant_5)
      @invoice_8 = create(:invoice)
      @transaction_s_8 = create(:transaction, result: 'success')
      @invoice_8.transactions << @transaction_s_8
      @invoice_9 = create(:invoice, created_at: '2012-03-13 07:54:10 UTC') # Tuesday, March 13, 2012
      @transaction_s_9 = create(:transaction, result: 'success')
      @invoice_9.transactions << @transaction_s_9
      @i_i_13 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_8)
      @i_i_14 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_9)
      @i_i_15 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_9)

      @merchant_6 = create(:merchant, name: "Steve Sews", status: 'Enabled')
      @item_6 = create(:item, merchant: @merchant_6)
      @invoice_10 = create(:invoice)
      @transaction_s_10 = create(:transaction, result: 'success')
      @invoice_10.transactions << @transaction_s_10
      @invoice_11 = create(:invoice, created_at: '2012-03-22 08:54:10 UTC') # Thurday, March 22, 2012
      @transaction_s_11 = create(:transaction, result: 'success')
      @invoice_11.transactions << @transaction_s_11
      @i_i_16 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_10)
      @i_i_17 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_11)
      @i_i_18 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_11)

      @merchant_7 = create(:merchant, name: "Vins Vinyl", status: 'Enabled')
      @item_7 = create(:item, merchant: @merchant_7)
      @invoice_12 = create(:invoice, created_at: '2012-03-27 07:54:11 UTC') # Tuesday, March 27, 2012
      @transaction_f = create(:transaction)
      @invoice_12.transactions << @transaction_f
      @i_i_19 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_12)
      @i_i_20 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_12)
      @i_i_21 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_12)
    end
    it 'has top merchants by revenue' do
      visit admin_merchants_path
      within('#top-merchants') do
        within("#top-#{@merchant_5.id}") do
          expect(page).to have_link(@merchant_5.name)
          expect(page).to have_content("$36.00 in sales")
        end
        within("#top-#{@merchant_6.id}") do
          expect(page).to have_link(@merchant_6.name)
          expect(page).to have_content("$30.00 in sales")
        end
        within("#top-#{@merchant_3.id}") do
          expect(page).to have_link(@merchant_3.name)
          expect(page).to have_content("$24.00 in sales")
        end
        within("#top-#{@merchant_4.id}") do
          expect(page).to have_link(@merchant_4.name)
          expect(page).to have_content("$18.00 in sales")
        end
        within("#top-#{@merchant_1.id}") do
          expect(page).to have_link(@merchant_1.name)
          expect(page).to have_content("$12.00 in sales")
        end
          expect(page).to_not have_content(@merchant_2.name)
          expect(page).to_not have_content(@merchant_7.name)

        expect(@merchant_5.name).to appear_before(@merchant_6.name)
        expect(@merchant_6.name).to appear_before(@merchant_3.name)
        expect(@merchant_3.name).to appear_before(@merchant_4.name)
        expect(@merchant_4.name).to appear_before(@merchant_1.name)
      end
    end

    it 'has best day for top merchants' do
      visit admin_merchants_path
      
      within('#top-merchants') do
        within("#top-#{@merchant_5.id}") do
          expect(page).to have_content("Top selling date for #{@merchant_5.name} was 03/13/12")
        end
        within("#top-#{@merchant_6.id}") do
          expect(page).to have_content("Top selling date for #{@merchant_6.name} was 03/22/12")
        end
        within("#top-#{@merchant_3.id}") do
          expect(page).to have_content("Top selling date for #{@merchant_3.name} was 03/21/12")
        end
        within("#top-#{@merchant_4.id}") do
          expect(page).to have_content("Top selling date for #{@merchant_4.name} was 03/10/12")
        end
        within("#top-#{@merchant_1.id}") do
          expect(page).to have_content("Top selling date for #{@merchant_1.name} was 03/25/12")
        end
      end
    end
  end
end
