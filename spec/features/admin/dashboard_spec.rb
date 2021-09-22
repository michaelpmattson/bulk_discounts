require 'rails_helper'

RSpec.describe 'Admin Dashboard page' do
  before(:each) do
    @merchant = create(:merchant)
    @item     = create(:item, merchant_id: @merchant.id)

    # 6 successful transactions, 1 failed
    @customer_1    = create(:customer)
    @invoice_1     = create(:invoice, customer_id: @customer_1.id, created_at: '2012-03-21 13:54:10 UTC') # Wednesday, March 21, 2012
    @invoice_item_1  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id, status: 1)
    @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    @transaction_2 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    @transaction_3 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    @transaction_4 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    @transaction_5 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    @transaction_6 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
    # failed
    @transaction_7 = create(:transaction, invoice_id: @invoice_1.id)

    # 5 successes
    @customer_2    = create(:customer)
    @invoice_2     = create(:invoice, customer_id: @customer_2.id)
    @invoice_item_2  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id, status: 2)
    @transaction_8 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
    @transaction_9 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
    @transaction_10 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
    @transaction_11 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
    @transaction_12 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')

    # 4 successes
    @customer_3    = create(:customer)
    @invoice_3     = create(:invoice, customer_id: @customer_3.id, created_at: '2012-03-24 15:54:10 UTC')
    @invoice_item_3  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id, status: 1) # Saturday, March 25, 2012
    @transaction_13 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
    @transaction_14 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
    @transaction_15 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
    @transaction_16 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')

    # 3 successes
    @customer_4    = create(:customer)
    @invoice_4     = create(:invoice, customer_id: @customer_4.id, created_at: '2012-03-25 09:54:09 UTC')
    @invoice_item_4  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id) # Sunday, March 25,2012)
    @transaction_17 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
    @transaction_18 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
    @transaction_19 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')

    # 2 successes
    @customer_5    = create(:customer)
    @invoice_5     = create(:invoice, customer_id: @customer_5.id)
    @invoice_item_5  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_5.id, status: 2)
    @transaction_20 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')
    @transaction_21 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')

    @customer_6    = create(:customer, first_name: 'Jill')
    @invoice_6     = create(:invoice, customer_id: @customer_6.id)
    @invoice_item_6  = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_6.id, status: 2)
    @transaction_1 = create(:transaction, invoice_id: @invoice_6.id, result: 'success')


    @merchant_2 = create(:merchant)
    @item_2     = create(:item, merchant_id: @merchant_2.id)

    @customer_7    = create(:customer)
    @invoice_7     = create(:invoice, customer_id: @customer_7.id)
    @invoice_item_7 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_7.id, status: 2)
    @transaction_7 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')
    @transaction_8 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')
    @transaction_9 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')

    visit '/admin'
  end
  context 'when i visit my admin dashboard' do
    it 'has a header that says admin dashboard' do
      expect(page).to have_content('Admin Dashboard')
    end

    it 'has a link to my admin merchants index' do
      click_link('Merchants')
      expect(current_path).to eq("/admin/merchants")
    end

    it 'has a link to my admin invoices index' do
      click_link('Invoices')
      expect(current_path).to eq("/admin/invoices")
    end
  end

  context 'top 5 customers' do
    it 'has the top 5 customers (most successful transactions)' do
      within '#top-customers' do
        expect(page).to     have_content(@customer_1.full_name)
        expect(page).to     have_content(@customer_2.full_name)
        expect(page).to     have_content(@customer_3.full_name)
        expect(page).to     have_content(@customer_4.full_name)
        expect(page).to     have_content(@customer_7.full_name)

        expect(page).to_not have_content(@customer_6.full_name)
      end
    end

    it 'has their number of successful transactions' do
      expect(page).to have_content('6 purchases')
    end
  end

  context 'incomplete invoices' do
    it 'has invoices with items not shipped' do
      expect(page).to have_content('Incomplete Invoices')
      within('#incomplete-invoices') do
        within("#incomplete-#{@invoice_1.id}") do
          expect(page).to have_content("##{@invoice_1.id}")
        end
        within("#incomplete-#{@invoice_3.id}") do
          expect(page).to have_content("##{@invoice_3.id}")
        end
        within("#incomplete-#{@invoice_4.id}") do
          expect(page).to have_content("##{@invoice_4.id}")
        end
        expect(page).to_not have_content("##{@invoice_2.id}")
        expect(page).to_not have_content("##{@invoice_5.id}")
        expect(page).to_not have_content("##{@invoice_6.id}")
        expect(page).to_not have_content("##{@invoice_7.id}")
      end
    end

    it 'links to show' do
      within('#incomplete-invoices') do
        within("#incomplete-#{@invoice_1.id}") do
          expect(page).to have_link("##{@invoice_1.id}")
          expect(page).to have_content("Wednesday, March 21, 2012")
        end
        within("#incomplete-#{@invoice_3.id}") do
          expect(page).to have_link("##{@invoice_3.id}")
          expect(page).to have_content("Saturday, March 24, 2012")
        end
        within("#incomplete-#{@invoice_4.id}") do
          expect(page).to have_link("##{@invoice_4.id}")
          expect(page).to have_content("Sunday, March 25, 2012")
          click_on "##{@invoice_4.id}"
        end
      end
      expect(current_path).to eq(admin_invoice_path(@invoice_4.id))
    end

    it 'orders by created at' do
      within('#incomplete-invoices') do
        expect("##{@invoice_4.id}").to appear_before("##{@invoice_3.id}")
        expect("##{@invoice_3.id}").to appear_before("##{@invoice_1.id}")
      end
    end
  end
end
