FactoryBot.define do
  factory :user do
    sequence(:name) { |i| "Name #{i}" }
    sequence(:email) { |i| "mail#{i}@mail.com" }
    sequence(:password) { |i| "123456789#{i}" }

    trait :admin do
      role 'admin'
    end

    trait :manager do
      role 'manager'
    end

    trait :regular do
      role 'regular'
    end
  end

  factory :zentime do
    user
    date_record Date.today.to_s
    time_record 30
  end
end
