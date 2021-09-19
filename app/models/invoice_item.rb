class InvoiceItem < ApplicationRecord
  enum status: [:packaged, :pending, :shipped, :unknown]

  belongs_to :item
  belongs_to :invoice
end
