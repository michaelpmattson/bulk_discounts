class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  def self.discounts_by_merchant_id(merchant_id)
    where(merchant_id: merchant_id)
  end
end
