class Invoice < ApplicationRecord
  enum status: [:packaged, :pending, :shipped, :unknown]

  belongs_to :customer
  has_many   :transactions,  dependent: :destroy
  has_many   :invoice_items, dependent: :destroy
  has_many   :items, through: :invoice_items

  def items_by_merchant_id(merchant_id)
    invoice_items.joins(:item).where(items: {merchant_id: merchant_id})
  end

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end

  def customer_name
    customer.full_name
  end

  def total_revenue_by_merchant_id(merchant_id)
    items_by_merchant_id(merchant_id).sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def total_revenue
    invoice_items.sum("quantity * unit_price")
  end
end
