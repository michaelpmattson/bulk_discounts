class BulkDiscount < ApplicationRecord
  validates :percentage, presence: true, numericality: {greater_than: 0, less_than: 101}
  validates :quantity_threshold, presence: true, numericality: {greater_than: 0}

  belongs_to :merchant

  def self.discounts_by_merchant_id(merchant_id)
    where(merchant_id: merchant_id)
  end
end
