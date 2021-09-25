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

    it 'has a link to edit the discount' do
      click_link('Edit Discount')
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant_1, @bulk_discount_11))

      expect(page).to have_field(:bulk_discount_quantity_threshold, with: @bulk_discount_11.quantity_threshold)
      expect(page).to have_field(:bulk_discount_percentage, with: @bulk_discount_11.percentage)

      fill_in(:bulk_discount_quantity_threshold, with: 35)
      fill_in(:bulk_discount_percentage,         with: 30)
      click_on('Update Discount')

      expect(page).to have_content('Quantity Threshold: 35')
      expect(page).to have_content('Percentage: 30%')
    end
  end
end
