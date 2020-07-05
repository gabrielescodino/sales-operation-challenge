FactoryBot.define do
  factory :sales_report do
    user
    income { 0 }
    created_at { '05/07/2020'.to_datetime }
    updated_at { 1.day.from_now }

    trait :finished do
      status { 'finished' }
    end
  end
end
