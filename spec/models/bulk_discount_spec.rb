require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:percentage) }
    it { should validate_presence_of(:quantity_threshold) }
    it { should validate_numericality_of(:percentage).is_greater_than(0) }
    it { should validate_numericality_of(:percentage).is_less_than(101) }
    it { should validate_numericality_of(:quantity_threshold).is_greater_than(0) }
  end

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
