require 'rails_helper'

RSpec.describe 'Merchant Items Index page' do
  context 'When I visit my merchant items index page' do
    before(:each) do
      @merchant_1 = create(:merchant)
      @item_1     = create(:item, merchant: @merchant_1) # cookies
      @item_2     = create(:item, merchant: @merchant_1, name: "crackers", status: "Enabled")
      @item_3     = create(:item, merchant: @merchant_1, name: "biscuits")
      @item_5     = create(:item, merchant: @merchant_1, name: "wafers", status: "Enabled")

      @merchant_2 = create(:merchant)
      @item_4     = create(:item, merchant: @merchant_2, name: "watermelon")

      visit "/merchants/#{@merchant_1.id}/items"
    end

    it 'lists the names of all my items' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_3.name)
    end

    it 'i do not see items for any other merchant' do
      expect(page).to_not have_content(@item_4.name)
    end

    it 'links to the merchant items show page from each item name' do
      click_link("#{@item_1.name}")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_1.id}")

      visit "/merchants/#{@merchant_1.id}/items"
      click_link("#{@item_2.name}")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_2.id}")

      visit "/merchants/#{@merchant_1.id}/items"
      click_link("#{@item_3.name}")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_3.id}")
    end

    it 'has a button for enable when item is disabled' do
      within "#item-#{@item_1.id}" do
        expect(page).to     have_button('Enable')
        expect(page).to_not have_button('Disable')

        click_button('Enable')
        expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")
      end
    end

    it 'has a button for disable when item is enabled' do
      within "#item-#{@item_2.id}" do
        expect(page).to     have_button('Disable')
        expect(page).to_not have_button('Enable')

        click_button('Disable')
        expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")
      end
    end

    it 'has sections for enabled and disabled' do
      within '#enabled' do
        expect(page).to     have_content('crackers')
        expect(page).to     have_content('wafers')
        expect(page).to_not have_content('cookies')
      end

      within '#disabled' do
        expect(page).to     have_content('cookies')
        expect(page).to     have_content('biscuits')
        expect(page).to_not have_content('crackers')
      end

      within "#item-#{@item_1.id}" do
        click_button('Enable')
      end

      within '#disabled' do
        expect(page).to_not have_content('cookies')
      end

      within '#enabled' do
        expect(page).to have_content('cookies')
      end
    end

    it 'has a link to create a new item' do
      click_link('New Item')
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/new")

      fill_in('item[name]',        with: 'cotton-candy')
      fill_in('item[description]', with: "it's mostly sugar")
      fill_in('item[unit_price]',  with: 11325)
      click_button('Submit')

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")
      expect(page).to have_content('cotton-candy')
    end
  end

  context '5 most popular items' do
    before(:each) do
      @merchant_1 = create(:merchant)

      @item_1 = create(:item, merchant_id: @merchant_1.id) # 12345
      @item_2 = create(:item, merchant_id: @merchant_1.id, name: 'cake')
      @item_3 = create(:item, merchant_id: @merchant_1.id, name: 'crackers')
      @item_4 = create(:item, merchant_id: @merchant_1.id, name: 'candy')
      @item_5 = create(:item, merchant_id: @merchant_1.id, name: 'biscuits')
      @item_6 = create(:item, merchant_id: @merchant_1.id, name: 'crisps')
      @item_7 = create(:item, merchant_id: @merchant_1.id, name: 'pickles')
      @item_8 = create(:item, merchant_id: @merchant_1.id, name: 'pie')
      @item_9 = create(:item, merchant_id: @merchant_1.id, name: 'carrots')

      @inv_11 = create(:invoice)
      @inv_12 = create(:invoice)
      @inv_13 = create(:invoice)
      @inv_14 = create(:invoice)
      @inv_15 = create(:invoice)
      @inv_16 = create(:invoice)
      @inv_17 = create(:invoice)
      @inv_18 = create(:invoice)
      @inv_19 = create(:invoice)

      @ii_11 = create(:invoice_item, item_id: @item_1.id, invoice_id: @inv_11.id) #12345
      @ii_12 = create(:invoice_item, item_id: @item_2.id, invoice_id: @inv_12.id, unit_price: 22345)
      @ii_13 = create(:invoice_item, item_id: @item_3.id, invoice_id: @inv_13.id, unit_price: 32345)
      @ii_14 = create(:invoice_item, item_id: @item_4.id, invoice_id: @inv_14.id, unit_price: 52345)
      @ii_15 = create(:invoice_item, item_id: @item_5.id, invoice_id: @inv_15.id, unit_price: 92345)
      @ii_16 = create(:invoice_item, item_id: @item_6.id, invoice_id: @inv_16.id, unit_price: 42345)
      @ii_17 = create(:invoice_item, item_id: @item_7.id, invoice_id: @inv_17.id, unit_price: 72345)
      @ii_18 = create(:invoice_item, item_id: @item_8.id, invoice_id: @inv_18.id, unit_price: 82345)
      @ii_19 = create(:invoice_item, item_id: @item_9.id, invoice_id: @inv_19.id, unit_price: 62345)

      @tr_11 = create(:transaction, result: 'success', invoice_id: @inv_11.id)
      @tr_12 = create(:transaction, result: 'success', invoice_id: @inv_12.id)
      @tr_13 = create(:transaction, result: 'success', invoice_id: @inv_13.id)
      @tr_14 = create(:transaction, result: 'success', invoice_id: @inv_14.id)
      @tr_15 = create(:transaction, result: 'success', invoice_id: @inv_15.id)
      @tr_16 = create(:transaction, result: 'success', invoice_id: @inv_16.id)

      @tr_17 = create(:transaction, invoice_id: @inv_17.id) #failed
      @tr_18 = create(:transaction, invoice_id: @inv_18.id) #failed
      @tr_19 = create(:transaction, invoice_id: @inv_19.id) #failed

      @merchant_2 = create(:merchant)
      @item_22 = create(:item, merchant_id: @merchant_2.id, unit_price: 999999, name: 'waffles')
      @inv_22 = create(:invoice)
      @ii_22 = create(:invoice_item, item_id: @item_22.id, invoice_id: @inv_22.id)
      @tr_22 = create(:transaction, result: 'success', invoice_id: @inv_22.id)

      visit "/merchants/#{@merchant_1.id}/items"
    end

    it 'shows names of top items by revenue generated' do
      within '#top-items' do
        expect(@item_5.name).to appear_before(@item_4.name)

        expect(page).to     have_content(@item_2.name)
        expect(page).to     have_content(@item_3.name)
        expect(page).to     have_content(@item_4.name)
        expect(page).to     have_content(@item_5.name)
        expect(page).to     have_content(@item_6.name)

        expect(page).to_not have_content(@item_1.name)
        expect(page).to_not have_content(@item_7.name)
      end
    end

    it 'links name to merchant item show page for item' do
      within '#top-items' do
        click_link(@item_6.name)
        expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_6.id}")
      end
    end

    it 'shows total revenue next to each item' do
      within '#top-items' do
        expectation = @ii_12.unit_price * @ii_12.quantity
        expect(page).to have_content(expectation)
      end
    end
  end
end
