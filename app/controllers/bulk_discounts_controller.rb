class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.discounts_by_merchant_id(params[:merchant_id])
    @upcoming_holidays = PublicHolidaysService.next_three
  end

  def new
  end

  def create
    merchant      = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.new(discount_params)
    if bulk_discount.save
      redirect_to merchant_bulk_discounts_path(merchant.id)
    else
      flash[:notice] = "Discount not created: Required information missing."
      redirect_to new_merchant_bulk_discount_path(merchant)
    end
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    discount.update(update_discount_params)
    redirect_to merchant_bulk_discount_path(discount.merchant, discount)
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

  def update_discount_params
    params.require(:bulk_discount).permit(:merchant_id, :percentage, :quantity_threshold)
  end
end
