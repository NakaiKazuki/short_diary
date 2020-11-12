FactoryBot.define do
  factory :user, class: User do
    email{"user@example.com"}
    password{"password"}
    password_confirmation{"password"}
  end
end
