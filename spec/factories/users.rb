FactoryBot.define do
  factory :user, class: User do
    email{ "user@example.com" }
    password{ "password" }
    password_confirmation{ "password" }
    confirmed_at { Date.today }

    trait :non_activate do
      confirmed_at { nil }
    end

    trait :other_email  do
      email{ "another@example.com" }
    end

    trait :account_freeze do
      locked_at { Date.today }
    end
  end
end
