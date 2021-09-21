require 'rails_helper'

RSpec.describe Invoice, type: :model do
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
      invoice = create(:invoice, created_at: 'Sun, 19 Sep 2021 11:11:11 UTC +00:00')
      expect(invoice.formatted_date).to eq("Sunday, September 19, 2021")
    end
  end

  describe '#customer_name' do
    it 'returns a customers full name' do
      customer = create(:customer)
      invoice = create(:invoice, customer_id: customer.id)
      expect(invoice.customer_name).to eq "John Doe"
    end
  end

  describe '#total_revenue' do
    it 'returns total revenue for an invoice' do
      item_1 = create(:item)
      item_2 = create(:item, name: "Hi-Chew")
      invoice_1 = create(:invoice, created_at: '2012-03-25 09:54:09 UTC') # Sunday, March 25,2012
      transaction_1 = create(:transaction, result: 'success')
      invoice_1.transactions << transaction_1
      invoice_1_item_1 = create(:invoice_item, item: item_1, quantity: 3, unit_price: 7, status: 1)
      invoice_1_item_2 = create(:invoice_item, item: item_2, quantity: 2, unit_price: 6, status: 2)
      invoice_1.invoice_items << invoice_1_item_1
      invoice_1.invoice_items << invoice_1_item_2

      expect(invoice_1.total_revenue).to eq(33)
    end
  end
end
