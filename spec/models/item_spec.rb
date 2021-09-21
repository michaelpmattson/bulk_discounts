require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end


  describe '.class methods' do
    before(:each) do
      @disabled_item_1 = create(:item)
      @disabled_item_2 = create(:item)
      @enabled_item_1  = create(:item, status: 'Enabled')
      @enabled_item_2  = create(:item, status: 'Enabled')
    end

    describe '.enabled' do
      it 'returns all enabled items' do
        expect(Item.enabled).to eq([@enabled_item_1, @enabled_item_2])
      end
    end

    describe '.disabled' do
      it 'returns all disabled items' do
        expect(Item.disabled).to eq([@disabled_item_1, @disabled_item_2])
      end
    end
  end

  describe '#instance methods' do
    before(:each) do
      @disabled_item_1 = create(:item)
      @disabled_item_2 = create(:item)
      @enabled_item_1  = create(:item, status: 'Enabled')
      @enabled_item_2  = create(:item, status: 'Enabled')
    end

    describe '#update_status!(enable, disable)' do
      it 'updates the status to Enabled or Disabled' do
        expect(@disabled_item_1.status).to eq("Disabled")
        @disabled_item_1.update_status!(true, nil)
        expect(@disabled_item_1.status).to eq("Enabled")

        expect(@enabled_item_1.status).to eq("Enabled")
        @enabled_item_1.update_status!(nil, true)
        expect(@enabled_item_1.status).to eq("Disabled")
      end
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

      @inv_11 = create(:invoice, created_at: "2012-03-25 09:54:09 UTC") #1
      @inv_12 = create(:invoice, created_at: "2012-03-12 05:54:09 UTC") #2
      @inv_13 = create(:invoice, created_at: "2012-03-10 00:54:09 UTC") #3
      @inv_14 = create(:invoice, created_at: "2012-03-24 15:54:10 UTC") #4
      @inv_15 = create(:invoice, created_at: "2012-03-07 19:54:10 UTC") #5
      @inv_16 = create(:invoice, created_at: "2012-03-09 01:54:10 UTC") #6
      @inv_17 = create(:invoice) #7
      @inv_18 = create(:invoice) #8
      @inv_19 = create(:invoice) #9
      @inv_20 = create(:invoice, created_at: "2012-03-07 21:54:10 UTC") #1
      @inv_21 = create(:invoice, created_at: "2012-03-13 16:54:10 UTC") #2
      @inv_22 = create(:invoice, created_at: "2012-03-16 13:54:11 UTC") #3
      @inv_23 = create(:invoice, created_at: "2012-03-06 21:54:10 UTC") #4
      @inv_24 = create(:invoice, created_at: "2012-03-07 12:54:10 UTC") #5
      @inv_25 = create(:invoice, created_at: "2012-03-27 07:54:11 UTC") #6

      @ii_11 = create(:invoice_item, item_id: @item_1.id, invoice_id: @inv_11.id) #12345
      @ii_12 = create(:invoice_item, item_id: @item_2.id, invoice_id: @inv_12.id, unit_price: 22345)
      @ii_13 = create(:invoice_item, item_id: @item_3.id, invoice_id: @inv_13.id, unit_price: 32345)
      @ii_14 = create(:invoice_item, item_id: @item_4.id, invoice_id: @inv_14.id, unit_price: 52345)
      @ii_15 = create(:invoice_item, item_id: @item_5.id, invoice_id: @inv_15.id, unit_price: 92345)
      @ii_16 = create(:invoice_item, item_id: @item_6.id, invoice_id: @inv_16.id, unit_price: 42345)
      @ii_17 = create(:invoice_item, item_id: @item_7.id, invoice_id: @inv_17.id, unit_price: 72345)
      @ii_18 = create(:invoice_item, item_id: @item_8.id, invoice_id: @inv_18.id, unit_price: 82345)
      @ii_19 = create(:invoice_item, item_id: @item_9.id, invoice_id: @inv_19.id, unit_price: 62345)
      @ii_20 = create(:invoice_item, item_id: @item_1.id, invoice_id: @inv_20.id, quantity: 20) #12345
      @ii_21 = create(:invoice_item, item_id: @item_2.id, invoice_id: @inv_21.id, unit_price: 22345, quantity: 20)
      @ii_22 = create(:invoice_item, item_id: @item_3.id, invoice_id: @inv_22.id, unit_price: 32345, quantity: 20)
      @ii_23 = create(:invoice_item, item_id: @item_4.id, invoice_id: @inv_23.id, unit_price: 52345, quantity: 20)
      @ii_24 = create(:invoice_item, item_id: @item_5.id, invoice_id: @inv_24.id, unit_price: 92345, quantity: 20)
      @ii_25 = create(:invoice_item, item_id: @item_6.id, invoice_id: @inv_25.id, unit_price: 42345, quantity: 20)

      @tr_11 = create(:transaction, result: 'success', invoice_id: @inv_11.id)
      @tr_12 = create(:transaction, result: 'success', invoice_id: @inv_12.id)
      @tr_13 = create(:transaction, result: 'success', invoice_id: @inv_13.id)
      @tr_14 = create(:transaction, result: 'success', invoice_id: @inv_14.id)
      @tr_15 = create(:transaction, result: 'success', invoice_id: @inv_15.id)
      @tr_16 = create(:transaction, result: 'success', invoice_id: @inv_16.id)
      @tr_20 = create(:transaction, result: 'success', invoice_id: @inv_20.id)
      @tr_21 = create(:transaction, result: 'success', invoice_id: @inv_21.id)
      @tr_22 = create(:transaction, result: 'success', invoice_id: @inv_22.id)
      @tr_23 = create(:transaction, result: 'success', invoice_id: @inv_23.id)
      @tr_24 = create(:transaction, result: 'success', invoice_id: @inv_24.id)
      @tr_25 = create(:transaction, result: 'success', invoice_id: @inv_25.id)

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
      expect(Item.top_items).to eq(expectation)
    end

    it 'has best day instance method' do
      expect(@item_1.best_day).to eq("2012-03-07 21:54:10 UTC")
      expect(@item_5.best_day).to eq("2012-03-07 12:54:10 UTC")
    end
  end
end

# describe '#enabled?' do
#   it 'confirms if enabled is true' do
#     expect(@disabled_item_1.disabled?).to eq(true)
#     expect(@enabled_item_1.disabled?).to eq(false)
#   end
# end
