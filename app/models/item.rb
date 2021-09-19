class Item < ApplicationRecord
  belongs_to :merchant
  has_many   :invoice_items, dependent: :destroy
  has_many   :invoices, through: :invoice_items

  def self.enabled
    where(status: "Enabled")
  end

  def self.disabled
    where(status: "Disabled")
  end

  def update_status!(enable, disable)
    if enable
      update(status: "Enabled")
    elsif disable
      update(status: "Disabled")
    end
  end

  def self.top_items
    joins(invoice_items: { invoice: :transactions }).
      where(transactions: {result: 'success'}).
      group(:id).
      select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total').
      order('total DESC').
      limit(5)
  end
end


# def disabled?
#   status == 'Disabled'
# end
