require 'rails_helper'

RSpec.describe 'the new bulk discount page' do
  before(:each) do
    stub_request(:get, "https://date.nager.at/api/v1/Get/US/#{Time.now.year}").to_return(body: File.read(File.join('spec', 'fixtures', 'nager_date_public_holidays.json')))

    @merchant_1       = create(:merchant)
    @bulk_discount_11 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_12 = create(:bulk_discount, merchant: @merchant_1, percentage: 25, quantity_threshold: 25)

    @merchant_2       = create(:merchant)
    @bulk_discount_21 = create(:bulk_discount, merchant: @merchant_2, percentage: 10, quantity_threshold: 10)

    visit new_merchant_bulk_discount_path(@merchant_1)
  end

  it 'can create a discount' do
    fill_in(:percentage,         with: 30)
    fill_in(:quantity_threshold, with: 30)
    click_on('Create Discount')

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

    expect(page).to have_content('Percentage: 30%')
    expect(page).to have_content('Quantity Threshold: 30')
  end

  it 'throws an error when user doesnt fill in the form' do
    fill_in(:percentage,         with: 30)
    click_on('Create Discount')

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    expect(page).to have_content("Discount not created: Required information missing.")

    fill_in(:quantity_threshold, with: 30)
    click_on('Create Discount')

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
    expect(page).to have_content("Discount not created: Required information missing.")
  end
end
