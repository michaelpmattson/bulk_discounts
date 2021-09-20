require 'rails_helper'

RSpec.describe 'Admin Dashboard page' do
  context 'when i visit my admin dashboard' do
    before(:each) do
      visit '/admin'
    end

    it 'has a header that says admin dashboard' do
      expect(page).to have_content('Admin Dashboard')
    end
  end
end
