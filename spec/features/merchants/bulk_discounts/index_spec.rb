require 'rails_helper'

RSpec.describe 'the merchant bulk discounts index' do
  before(:each) do
    @merchant_1       = create(:merchant)
    @bulk_discount_11 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_12 = create(:bulk_discount, merchant: @merchant_1, percentage: 0.25, quantity_threshold: 20)

    @merchant_2       = create(:merchant)
    @bulk_discount_21 = create(:bulk_discount, merchant: @merchant_2, percentage: 0.10, quantity_threshold: 10)

    visit merchant_bulk_discounts_path(@merchant_1)
  end

  it 'shows all the bulk discounts for a merchant' do
    within "#discount-#{@bulk_discount_11.id}" do
      expect(page).to have_content((@bulk_discount_11.percentage * 100).round(0))
      expect(page).to have_content(@bulk_discount_11.quantity_threshold)
      expect(page).to have_link("View Discount")
      click_link("View Discount")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_11))
    end

    visit merchant_bulk_discounts_path(@merchant_1)
    within "#discount-#{@bulk_discount_12.id}" do
      expect(page).to have_content((@bulk_discount_12.percentage * 100).round(0))
      expect(page).to have_content(@bulk_discount_12.quantity_threshold)
      expect(page).to have_link("View Discount")
    end

    expect(page).to_not have_content(@bulk_discount_21.percentage)
  end

  it 'has a link to create a new discount' do
    click_link('Add New Discount')
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))

    fill_in(:percentage,         with: 25)
    fill_in(:quantity_threshold, with: 30)
    click_on('Create Discount')

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

    expect(page).to have_content('Percentage: 25%')
    expect(page).to have_content('Quantity Threshold: 30')
  end
end
