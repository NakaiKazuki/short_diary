# == Schema Information
#
# Table name: favorites
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  micropost_id :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_favorites_on_micropost_id              (micropost_id)
#  index_favorites_on_user_id                   (user_id)
#  index_favorites_on_user_id_and_micropost_id  (user_id,micropost_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (micropost_id => microposts.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :favorite, class: 'Favorite' do
    association :user, factory: :user
    association :micropost, factory: :micropost
  end
end
