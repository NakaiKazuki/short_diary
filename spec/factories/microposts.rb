FactoryBot.define do
  factory :micropost,class: Micropost do
    content { "テストcontent" }
    association :user, factory: :user

    trait :add_picture do
      picture { Rack::Test::UploadedFile.new(Rails.root.join("spec", "fixtures", "images", "test.jpg"))}
    end
  end
end
