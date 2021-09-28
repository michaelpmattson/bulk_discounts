class MerchantInvoicesController < ApplicationController
  before_action :find_merchant

  def index
    @invoices = @merchant.invoices.distinct
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items_by_merchant_id(params[:merchant_id])
    @revenue = @invoice.total_revenue_by_merchant_id(params[:merchant_id])
    @discounted_revenue = @invoice.discounted_revenue(@revenue, @invoice.discounted_inv_items_by_merchant_id(@merchant.id))
  end

private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
