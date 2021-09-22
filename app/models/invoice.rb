class Invoice < ApplicationRecord
  enum status: [:cancelled, 'in progress', :completed, :unknown]

  belongs_to :customer
  has_many   :transactions,  dependent: :destroy
  has_many   :invoice_items, dependent: :destroy
  has_many   :items, through: :invoice_items

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end

  def customer_name
    customer.full_name
  end

  def total_revenue
    invoice_items.sum("quantity * unit_price")
  end
end
