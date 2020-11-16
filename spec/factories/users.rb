FactoryBot.define do
  factory :user, class: User do
    email{"user@example.com"}
    password{"password"}
    password_confirmation{"password"}
    confirmed_at { Date.today }

    trait :confirmed_nil do
      confirmed_at { nil }
    end
  end
end
