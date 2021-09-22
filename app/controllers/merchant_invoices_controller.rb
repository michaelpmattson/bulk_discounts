class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.distinct
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.items_by_merchant_id(params[:merchant_id])
    @revenue = @invoice.total_revenue_by_merchant_id(params[:merchant_id])
  end
end
