FactoryBot.define do
  factory :invoice do
    status { 0 }
    customer
  end
end
