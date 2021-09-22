class AdminController < ApplicationController
  def index
    @customers = Customer.all
    @incomplete_invoices = Invoice.incomplete
  end
end
