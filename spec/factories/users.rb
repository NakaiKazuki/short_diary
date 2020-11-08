FactoryBot.define do
  factory :user, class: User do
    name{"Example User"}
    email{"user@example.com"}
    password{"foobar"}
    password_confirmation{"foobar"}
  end
end
