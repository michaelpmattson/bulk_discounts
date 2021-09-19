class Invoice < ApplicationRecord
  belongs_to :customer
  has_many   :transactions,  dependent: :destroy
  has_many   :invoice_items, dependent: :destroy
  has_many   :items, through: :invoice_items

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end
end
