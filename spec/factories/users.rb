FactoryBot.define do
  factory :user, class: User do
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.now }

    trait :non_activate do
      confirmed_at { nil }
    end

    trait :other_email  do
      email { "another@example.com" }
    end

    trait :account_freeze do
      locked_at { Time.now }
    end
  end

  factory :guest, class: User do
    email { "guest@example.com" }
    password { "password" }
    password_confirmation { "password" }
    confirmed_at { Time.now }
  end

end
