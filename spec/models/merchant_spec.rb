require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many(:items).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#instance methods' do
    before(:each) do
      @merchant = create(:merchant)
      @merchant_2 = create(:merchant, name: "Jennys Jewels", status: 'Enabled')
      @disabled_item_1 = create(:item, merchant: @merchant)
      @disabled_item_2 = create(:item, merchant: @merchant)
      @enabled_item_1  = create(:item, merchant: @merchant, status: 'Enabled')
      @enabled_item_2  = create(:item, merchant: @merchant, status: 'Enabled')
    end

    describe 'enabled and disabled items' do
      it 'returns the merchants enabled items' do
        expect(@merchant.enabled_items).to eq([@enabled_item_1, @enabled_item_2])
      end

      it 'returns the merchants disabled items' do
        expect(@merchant.disabled_items).to eq([@disabled_item_1, @disabled_item_2])
      end
    end

    describe 'update_status' do
      it 'updates merchant status' do
        @merchant_2.update_status('Disabled')
        expect(@merchant_2.status).to eq('Disabled')
        @merchant.update_status('Enabled')
        expect(@merchant.status).to eq('Enabled')
      end
    end
  end

  describe '#class methods' do
    before(:each) do
      @merchant = create(:merchant)
      @merchant_2 = create(:merchant, name: "Jennys Jewels", status: 'Enabled')
      @disabled_item_1 = create(:item, merchant: @merchant)
      @disabled_item_2 = create(:item, merchant: @merchant)
      @enabled_item_1  = create(:item, merchant: @merchant, status: 'Enabled')
      @enabled_item_2  = create(:item, merchant: @merchant, status: 'Enabled')
    end

    it '#enabled_merchants' do
      expect(Merchant.enabled_merchants).to eq([@merchant_2])
    end

    it '#disabled_merchants' do
      expect(Merchant.disabled_merchants).to eq([@merchant])
    end
  end

  describe '#favorite_customers' do
    before(:each) do
      @merchant = create(:merchant)
      @item     = create(:item, merchant_id: @merchant.id)

      # 5 successes
      @customer_2    = create(:customer)
      @invoice_2     = create(:invoice, customer_id: @customer_2.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_2.id)
      @transaction_8 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_9 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_10 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_11 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')
      @transaction_12 = create(:transaction, invoice_id: @invoice_2.id, result: 'success')

      # 4 successes
      @customer_3    = create(:customer)
      @invoice_3     = create(:invoice, customer_id: @customer_3.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_3.id)
      @transaction_13 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_14 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_15 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')
      @transaction_16 = create(:transaction, invoice_id: @invoice_3.id, result: 'success')

      # 3 successes
      @customer_4    = create(:customer)
      @invoice_4     = create(:invoice, customer_id: @customer_4.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_4.id)
      @transaction_17 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      @transaction_18 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')
      @transaction_19 = create(:transaction, invoice_id: @invoice_4.id, result: 'success')

      # 2 successes
      @customer_5    = create(:customer)
      @invoice_5     = create(:invoice, customer_id: @customer_5.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_5.id)
      @transaction_20 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')
      @transaction_21 = create(:transaction, invoice_id: @invoice_5.id, result: 'success')

      @customer_6    = create(:customer, first_name: 'Jill')
      @invoice_6     = create(:invoice, customer_id: @customer_6.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_6.id)
      @transaction_1 = create(:transaction, invoice_id: @invoice_6.id, result: 'success')

      @customer_1    = create(:customer)
      @invoice_1     = create(:invoice, customer_id: @customer_1.id)
      @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice_1.id)
      @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_2 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_3 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_4 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_5 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')
      @transaction_6 = create(:transaction, invoice_id: @invoice_1.id, result: 'success')

      # failed
      @transaction_7 = create(:transaction, invoice_id: @invoice_1.id)
    end

    it 'gives the top five for the merchant' do
      expect(@merchant.favorite_customers).to eq([@customer_1, @customer_2, @customer_3, @customer_4, @customer_5])
    end
  end

  context 'inv_items_ready' do
    before(:each) do
      @merchant    = create(:merchant)

      @good_item_1 = create(:item, merchant_id: @merchant.id)
      @g_in_item_1 = create(:invoice_item, item_id: @good_item_1.id)
      @good_item_2 = create(:item, merchant_id: @merchant.id, name: 'crackers')
      @g_in_item_2 = create(:invoice_item, item_id: @good_item_2.id)
      @good_item_3 = create(:item, merchant_id: @merchant.id, name: 'pickles')
      @g_in_item_3 = create(:invoice_item, item_id: @good_item_3.id, status: 1)
      @good_item_4 = create(:item, merchant_id: @merchant.id, name: 'biscuits')
      @g_in_item_4 = create(:invoice_item, item_id: @good_item_4.id, status: 1)

      @bad_item_1  = create(:item, merchant_id: @merchant.id, name: 'candy')
      @b_in_item_1 = create(:invoice_item, item_id: @bad_item_1.id, status: 2)
      @bad_item_2  = create(:item, merchant_id: @merchant.id, name: 'walnuts')
      @b_in_item_2 = create(:invoice_item, item_id: @bad_item_2.id, status: 3)
    end

    it 'returns invoice items that are not shipped or unknown' do
      expect(@merchant.inv_items_ready).to eq([@g_in_item_1, @g_in_item_2, @g_in_item_3, @g_in_item_4])
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
    end

    it 'returns top five successful items by revenue' do
      expectation = [@item_5, @item_4, @item_6, @item_3, @item_2]
      expect(@merchant_1.top_items).to eq(expectation)
    end
  end
end


# describe 'disabled?' do
#   it 'returns true is disabled' do
#     expect(@merchant.disabled?).to eq(true)
#     expect(@merchant_2.disabled?).to eq(false)
#   end
# end
