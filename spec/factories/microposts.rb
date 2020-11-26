FactoryBot.define do
  factory :micropost,class: Micropost do
    content { "テストcontent" }
    posted_date { Date.today }
    association :user, factory: :user
  end
end
