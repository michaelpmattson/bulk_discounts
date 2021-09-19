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
      @transaction_f = create(:transaction)
      @merchant_1 = create(:merchant)
      @enabled_item_1  = create(:item, merchant: @merchant_1, status: 'Enabled')
      @invoice_1 = create(:invoice)
      @invoice_1.transactions << @transaction_s
      @i_i_1 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1)
      @i_i_2 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1)
      @i_i_3 = create(:invoice_item, item: @enabled_item_1, unit_price: 2, quantity: 2, invoice: @invoice_1)

      @merchant_2 = create(:merchant, name: "Jennys Jewels", status: 'Enabled')
      @item_2 = create(:item, merchant: @merchant_2)
      @invoice_2 = create(:invoice)
      @transaction_s_2 = create(:transaction, result: 'success')
      @invoice_2.transactions << @transaction_s_2
      @i_i_4 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_2)
      @i_i_5 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_2)
      @i_i_6 = create(:invoice_item, item: @item_2, unit_price: 2, quantity: 1, invoice: @invoice_2)

      @merchant_3 = create(:merchant, name: "Super Sam", status: 'Enabled')
      @item_3 = create(:item, merchant: @merchant_3)
      @invoice_3 = create(:invoice)
      @transaction_s_3 = create(:transaction, result: 'success')
      @invoice_3.transactions << @transaction_s_3
      @i_i_7 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_3)
      @i_i_8 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_3)
      @i_i_9 = create(:invoice_item, item: @item_3, unit_price: 2, quantity: 4, invoice: @invoice_3)

      @merchant_4 = create(:merchant, name: "Random Rogers", status: 'Enabled')
      @item_4 = create(:item, merchant: @merchant_4)
      @invoice_4 = create(:invoice)
      @transaction_s_4 = create(:transaction, result: 'success')
      @invoice_4.transactions << @transaction_s_4
      @i_i_10 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_4)
      @i_i_11 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_4)
      @i_i_12 = create(:invoice_item, item: @item_4, unit_price: 2, quantity: 3, invoice: @invoice_4)

      @merchant_5 = create(:merchant, name: "Caras Cupcakes", status: 'Enabled')
      @item_5 = create(:item, merchant: @merchant_5)
      @invoice_5 = create(:invoice)
      @transaction_s_5 = create(:transaction, result: 'success')
      @invoice_5.transactions << @transaction_s_5
      @i_i_13 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_5)
      @i_i_14 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_5)
      @i_i_15 = create(:invoice_item, item: @item_5, unit_price: 2, quantity: 6, invoice: @invoice_5)

      @merchant_6 = create(:merchant, name: "Steve Sews", status: 'Enabled')
      @item_6 = create(:item, merchant: @merchant_6)
      @invoice_6 = create(:invoice)
      @transaction_s_6 = create(:transaction, result: 'success')
      @invoice_6.transactions << @transaction_s_6
      @i_i_16 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_6)
      @i_i_17 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_6)
      @i_i_18 = create(:invoice_item, item: @item_6, unit_price: 2, quantity: 5, invoice: @invoice_6)

      @merchant_7 = create(:merchant, name: "Vins Vinyl", status: 'Enabled')
      @item_7 = create(:item, merchant: @merchant_7)
      @invoice_7 = create(:invoice)
      @invoice_7.transactions << @transaction_f
      @i_i_19 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_7)
      @i_i_20 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_7)
      @i_i_21 = create(:invoice_item, item: @item_7, unit_price: 2, quantity: 6, invoice: @invoice_7)
    end
    it 'has top merchants by revenue' do
      visit admin_merchants_path
      within('#top-merchants') do
        expect(page).to have_link(@merchant_5.name)
        expect(page).to have_link(@merchant_6.name)
        expect(page).to have_link(@merchant_3.name)
        expect(page).to have_link(@merchant_4.name)
        expect(page).to have_link(@merchant_1.name)
        expect(page).to_not have_content(@merchant_2.name)
        expect(page).to_not have_content(@merchant_7.name)

        expect(@merchant_5.name).to appear_before(@merchant_6.name)
        expect(@merchant_6.name).to appear_before(@merchant_3.name)
        expect(@merchant_3.name).to appear_before(@merchant_4.name)
        expect(@merchant_4.name).to appear_before(@merchant_1.name)
        save_and_open_page
      end
    end
  end
end
