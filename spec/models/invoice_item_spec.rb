require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe 'enums' do
    it { should define_enum_for(:status) }

    it 'can be packaged' do
      invoice_item = build(:invoice_item)
      expect(invoice_item.status).to eq('packaged')
    end

    it 'can be pending' do
      invoice_item = build(:invoice_item, status: 1)
      expect(invoice_item.status).to eq('pending')
    end

    it 'can be shipped' do
      invoice_item = build(:invoice_item, status: 2)
      expect(invoice_item.status).to eq('shipped')
    end

    it 'can be unknown' do
      invoice_item = build(:invoice_item, status: 3)
      expect(invoice_item.status).to eq('unknown')
    end
  end

  describe '#instance methods' do
    before(:each) do
      @item     = create(:item)
      @inv_item = create(:invoice_item, item_id: @item.id)
    end

    describe '#item_name' do
      it 'returns an item name' do
        expect(@inv_item.item_name).to eq(@item.name)
      end
    end

    describe '#formatted_date' do
      it 'returns the creation date of the invoice' do
        invoice = create(:invoice, created_at: 'Sun, 19 Sep 2021 11:11:11 UTC +00:00')
        invoice_item = create(:invoice_item, invoice_id: invoice.id)
        expect(invoice_item.formatted_date).to eq("Sunday, September 19, 2021")
      end
    end

    describe '#discount' do
      it 'returns the discount for the invoice item' do
        merchant_a       = create(:merchant)
        bulk_discount_a1 = create(:bulk_discount, merchant: merchant_a, percentage: 20, quantity_threshold: 10)
        bulk_discount_a2 = create(:bulk_discount, merchant: merchant_a, percentage: 30, quantity_threshold: 15)
        item_a1          = create(:item, merchant: merchant_a)
        invoice_a        = create(:invoice)
        invoice_item_a1  = create(:invoice_item, item: item_a1, invoice: invoice_a, quantity: 12)

        merchant_b       = create(:merchant)
        bulk_discount_b  = create(:bulk_discount, merchant: merchant_b, percentage: 20, quantity_threshold: 10)
        item_b           = create(:item, merchant: merchant_b)
        invoice_item_b   = create(:invoice_item, item: item_b, invoice: invoice_a, quantity: 15)

        transaction_a    = create(:transaction, invoice: invoice_a, result: 'success')

        expect(invoice_item_a1.discount).to eq(bulk_discount_a1)
      end

      it 'returns the best discount for the invoice item' do
        merchant_a       = create(:merchant)
        bulk_discount_a1 = create(:bulk_discount, merchant: merchant_a, percentage: 20, quantity_threshold: 10)
        bulk_discount_a2 = create(:bulk_discount, merchant: merchant_a, percentage: 30, quantity_threshold: 15)
        item_a1          = create(:item, merchant: merchant_a)
        invoice_a        = create(:invoice)
        invoice_item_a1  = create(:invoice_item, item: item_a1, invoice: invoice_a, quantity: 15)

        transaction_a    = create(:transaction, invoice: invoice_a, result: 'success')

        expect(invoice_item_a1.discount).to eq(bulk_discount_a2)
      end
    end
  end
end
