require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:each) do
    @customer = create(:customer)

    @item_1 = create(:item)
    @item_2 = create(:item, name: "Hi-Chew")

    @invoice_1 = create(:invoice, created_at: '2012-03-25 09:54:09 UTC') # Sunday, March 25,2012
    @transaction_1 = create(:transaction, result: 'success')
    @invoice_1.transactions << @transaction_1
    @invoice_1_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 1)
    @invoice_1_item_2 = create(:invoice_item, item: @item_2, quantity: 2, unit_price: 6, status: 2)
    @invoice_1.invoice_items << @invoice_1_item_1
    @invoice_1.invoice_items << @invoice_1_item_2

    @invoice_2 = create(:invoice, created_at: '2012-03-25 09:54:09 UTC') # Sunday, March 25,2012
    @transaction_2 = create(:transaction)
    @invoice_2.transactions << @transaction_2
    @invoice_2_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 1)
    @invoice_2_item_2 = create(:invoice_item, item: @item_2, quantity: 2, unit_price: 6, status: 2)
    @invoice_2.invoice_items << @invoice_2_item_1
    @invoice_2.invoice_items << @invoice_2_item_2

    @invoice_3 = create(:invoice, status: 1)
    @transaction_3 = create(:transaction)
    @transaction_4 = create(:transaction, result: 'success')
    @invoice_3.transactions << @transaction_3
    @invoice_3.transactions << @transaction_4


    @invoice_4 = create(:invoice, created_at: 'Sun, 19 Sep 2021 11:11:11 UTC +00:00')
    @invoice_4_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 2)
    @transaction_5 = create(:transaction, result: 'success')
    @invoice_4.transactions << @transaction_5
    @invoice_4.invoice_items << @invoice_4_item_1

    @invoice_5 = create(:invoice, customer_id: @customer.id, status: 2)
    @invoice_5_item_1 = create(:invoice_item, item: @item_1, quantity: 3, unit_price: 7, status: 2)
    @transaction_6 = create(:transaction, result: 'success')
    @invoice_5.transactions << @transaction_6
    @invoice_5.invoice_items << @invoice_5_item_1
  end
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions).dependent(:destroy) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'enums' do
    it { should define_enum_for(:status) }
  end
  describe '#formatted_date' do
    it 'returns the date with weekday, month, date, year' do
      expect(@invoice_4.formatted_date).to eq("Sunday, September 19, 2021")
    end
  end

  describe '#customer_name' do
    it 'returns a customers full name' do
      expect(@invoice_5.customer_name).to eq "John Doe"
    end
  end

  describe '#total_revenue' do
    it 'returns total revenue for a paid invoice' do
      expect(@invoice_1.total_revenue).to eq(33)
      expect(@invoice_2.total_revenue).to eq(0)
    end
  end

  describe '#paid?' do
    it '#identifies invoices with successful transactions' do
      expect(@invoice_1.paid?).to eq(true)
      expect(@invoice_2.paid?).to eq(false)
      expect(@invoice_3.paid?).to eq(true)
    end
  end

  describe '#incomplete' do
    it '#returns invoices with items not shipped' do
      expect(Invoice.incomplete).to eq([@invoice_1, @invoice_2])
    end
  end
end
