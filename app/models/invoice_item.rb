class InvoiceItem < ApplicationRecord
  enum status: [:packaged, :pending, :shipped, :unknown]

  belongs_to :item
  belongs_to :invoice

  def item_name
    item.name
  end

  def formatted_date
    invoice.formatted_date
  end

  def discount
    wip = BulkDiscount.joins(merchant: {items: {invoice_items: {invoice: :transactions}}})
    .where("quantity_threshold <= #{quantity} AND transactions.result = 'success' AND invoice_items.id =  #{id}")
    .order(percentage: :desc)
    .first
  end
end
