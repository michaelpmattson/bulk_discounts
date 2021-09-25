FactoryBot.define do
  factory :bulk_discount do
    percentage { 20 }
    quantity_threshold { 15 }
    merchant
  end
end
