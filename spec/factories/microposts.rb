# == Schema Information
#
# Table name: microposts
#
#  id         :bigint           not null, primary key
#  content    :text(65535)      not null
#  picture    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_microposts_on_user_id                 (user_id)
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :micropost, class: 'Micropost' do
    content { 'テストcontent' }
    association :user, factory: :user

    trait :add_picture do
      picture {
        Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/test.jpg'))
      }
    end
  end
end
