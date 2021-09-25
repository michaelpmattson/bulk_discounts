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
    end
  end
end


# Then I am taken to a new page with a form to edit the discount
# And I see that the discounts current attributes are pre-poluated in the form
# When I change any/all of the information and click submit
# Then I am redirected to the bulk discount's show page
# And I see that the discount's attributes have been updated
