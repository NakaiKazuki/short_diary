# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  unconfirmed_email      :string(255)
#  unlock_token           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user, class: 'User' do
    email { 'user@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { Time.current }

    trait :non_activate do
      confirmed_at { nil }
    end

    trait :other_email do
      email { 'another@example.com' }
    end

    trait :account_freeze do
      locked_at { Time.current }
    end
  end

  factory :guest, class: 'User' do
    email { 'guest@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    confirmed_at { Time.current }
  end
end
