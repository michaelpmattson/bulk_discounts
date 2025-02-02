require 'rails_helper'

RSpec.describe 'the merchant bulk discounts index' do
  before(:each) do
    stub_request(:get, "https://date.nager.at/api/v1/Get/US/#{Time.now.year}").to_return(body: File.read(File.join('spec', 'fixtures', 'nager_date_public_holidays.json')))

    @merchant_1       = create(:merchant)
    @bulk_discount_11 = create(:bulk_discount, merchant: @merchant_1)
    @bulk_discount_12 = create(:bulk_discount, merchant: @merchant_1, percentage: 25, quantity_threshold: 25)

    @merchant_2       = create(:merchant)
    @bulk_discount_21 = create(:bulk_discount, merchant: @merchant_2, percentage: 10, quantity_threshold: 10)

    visit merchant_bulk_discounts_path(@merchant_1)
  end

  it 'shows all the bulk discounts for a merchant' do
    within "#discount-#{@bulk_discount_11.id}" do
      expect(page).to have_content(@bulk_discount_11.percentage)
      expect(page).to have_content(@bulk_discount_11.quantity_threshold)
      expect(page).to have_link("View Discount")
      click_link("View Discount")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant_1, @bulk_discount_11))
    end

    visit merchant_bulk_discounts_path(@merchant_1)
    within "#discount-#{@bulk_discount_12.id}" do
      expect(page).to have_content(@bulk_discount_12.percentage)
      expect(page).to have_content(@bulk_discount_12.quantity_threshold)
      expect(page).to have_link("View Discount")
    end

    expect(page).to_not have_content(@bulk_discount_21.percentage)
  end

  it 'has a link to create a new discount' do
    click_link('Add New Discount')
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant_1))
  end

  it 'has a link to delete each discount' do
    within "#discount-#{@bulk_discount_11.id}" do
      expect(page).to have_link('Delete Discount')
      click_link('Delete Discount')
    end
    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant_1))

    within "#discount-#{@bulk_discount_12.id}" do
      expect(page).to have_link('Delete Discount')
    end

    expect(page).to_not have_content("Percentage: #{@bulk_discount_11.percentage}")
    expect(page).to_not have_content("Quantity Threshold: #{@bulk_discount_11.quantity_threshold}")
  end

  it 'has an upcoming holidays section with next 3 names and dates' do
    within '#upcoming-holidays' do
      expect(page).to have_content("Upcoming Holidays:")
      expect(page).to have_content("Veterans Day, 2021-11-11")
      expect(page).to have_content("Thanksgiving Day, 2021-11-25")
      expect(page).to have_content("Christmas Day, 2021-12-24")
    end
  end
end
