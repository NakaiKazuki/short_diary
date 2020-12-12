class User < ApplicationRecord
  has_many :microposts, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable
  # 未使用:trackable and :omniauthable
  before_save :downcase_email

  validates :email,
            presence: true,
            length: { maximum: 255 }

  class << self
    def guest
      find_or_create_by!(email: 'guest@example.com') do |user|
        user.password = SecureRandom.urlsafe_base64
        user.confirmed_at = Time.current
      end
    end
  end

  private

    def downcase_email
      email.downcase!
    end
end
