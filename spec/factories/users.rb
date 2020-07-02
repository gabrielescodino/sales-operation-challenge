FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'johndoe@gmail.com' }
    google_uid { 'abc123' }
  end
end
