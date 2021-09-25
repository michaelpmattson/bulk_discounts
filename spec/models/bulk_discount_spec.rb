require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe '.class methods' do
    describe '.discounts_by_merchant_id(merchant_id)' do
      it 'finds all discounts by merchant id' do
        merchant_1       = create(:merchant)
        bulk_discount_11 = create(:bulk_discount, merchant: merchant_1)
        bulk_discount_12 = create(:bulk_discount, merchant: merchant_1)
        discounts = BulkDiscount.discounts_by_merchant_id(merchant_1.id)

        expect(discounts).to eq([bulk_discount_11, bulk_discount_12])
      end
    end
  end
end
