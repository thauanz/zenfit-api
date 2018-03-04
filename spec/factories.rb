FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "Name #{i}" }
    sequence(:email) { |i| "mail#{i}@mail.com" }
    password '123456789'
  end

  factory :zentime do
    user
    date_record Date.today.to_s
    time_record 30
  end
end
