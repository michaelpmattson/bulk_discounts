require 'rails_helper'

RSpec.describe 'bulk discount show page', type: :feature do
  context 'as a merchant, when i visit my show page' do
    before(:each) do
      @merchant_1       = create(:merchant)
      @bulk_discount_11 = create(:bulk_discount, merchant: @merchant_1)
      visit merchant_bulk_discount_path(@merchant_1, @bulk_discount_11)
    end

    it 'displays the quantity threshold and percentage' do
      expect(page).to have_content(@bulk_discount_11.quantity_threshold)
      expect(page).to have_content(@bulk_discount_11.percentage)
    end
  end
end
