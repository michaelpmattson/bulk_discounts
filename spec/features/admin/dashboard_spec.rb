require 'rails_helper'

RSpec.describe 'Admin Dashboard page' do
  context 'when i visit my admin dashboard' do
    before(:each) do
      visit '/admin'
    end

    it 'has a header that says admin dashboard' do
      expect(page).to have_content('Admin Dashboard')
    end

    it 'has a link to my admin merchants index' do
      click_link('Merchants')
      expect(current_path).to eq("/admin/merchants")
    end

    it 'has a link to my admin invoices index' do
      click_link('Invoices')
      expect(current_path).to eq("/admin/invoices")
    end
  end
end

# As an admin,
# When I visit the admin dashboard (/admin)
# Then I see a link to the admin merchants index (/admin/merchants)
# And I see a link to the admin invoices index (/admin/invoices)
