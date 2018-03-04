FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "Name #{i}" }
    sequence(:email) { |i| "mail#{i}@mail.com" }
    password '123456789'
  end
end
