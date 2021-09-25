class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.discounts_by_merchant_id(params[:merchant_id])
  end

  def new

  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    merchant.bulk_discounts.create(discount_params)
    redirect_to merchant_bulk_discounts_path(merchant.id)
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path
  end

  private

  def discount_params
    params.permit(:merchant_id, :percentage, :quantity_threshold)
  end
end
