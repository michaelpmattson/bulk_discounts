require 'rails_helper'

RSpec.describe 'admin merchant edit page' do
  before(:each) do
    @merchant_1 = create(:merchant)
  end

  it 'can edit the merchant' do
    visit "/admin/merchants/#{@merchant_1.id}"
    click_on "Edit #{@merchant_1.name}"

    expect(page).to have_field('merchant[name]', with: 'Sprouts')
    fill_in 'Name', with: 'Fresh Thyme'
    click_button 'Update Merchant'

    expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")

    within("#flash-message") do
      expect(page).to have_content("Fresh Thyme has been successfully updated!")
    end
    expect(page).to have_content('Fresh Thyme')
  end
end
