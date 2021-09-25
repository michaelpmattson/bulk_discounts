class BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.discounts_by_merchant_id(params[:merchant_id])
  end

  def new

  end

  def show

  end
end
