FactoryBot.define do
  factory :sale do
    item_price { 10000 }
    purchase_count { 2 }
    sales_report
    customer
    merchant
    item
    created_at { '07/07/2020'.to_datetime }
  end
end
