require 'rails_helper'

RSpec.describe 'admin invoices index page', type: :feature do
  before(:each) do
    @invoice_1 = create(:invoice, created_at: '2012-03-25 09:54:09 UTC') # Sunday, March 25,2012
    @transaction_1 = create(:transaction, result: 'success')
    @invoice_1.transactions << @transaction_1
    @invoice_2 = create(:invoice, created_at: '2012-03-24 15:54:10 UTC') # Saturday, March 25, 2012
    @transaction_2 = create(:transaction)
    @invoice_2.transactions << @transaction_2
    @invoice_3 = create(:invoice, created_at: '2012-03-21 13:54:10 UTC') # Wednesday, March 21, 2012
    @transaction_3 = create(:transaction, result: 'success')
    @invoice_3.transactions << @transaction_3
    visit admin_invoices_path
  end

  it 'lists all invoices' do
    within("#invoice-#{@invoice_1.id}") do
      expect(page).to have_link("Invoice ##{@invoice_1.id}")
    end
    within("#invoice-#{@invoice_2.id}") do
      expect(page).to have_link("Invoice ##{@invoice_2.id}")
    end
    within("#invoice-#{@invoice_3.id}") do
      expect(page).to have_link("Invoice ##{@invoice_3.id}")
    end
  end

  it 'invoice ids link to show page' do
    within("#invoice-#{@invoice_1.id}") do
      click_on "Invoice ##{@invoice_1.id}"
    end
    expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
  end
end
