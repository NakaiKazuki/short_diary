class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # 未使用 :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  before_save :downcase_email

  validates :email,
    presence: true,
    length: { maximum: 255 }

  private
    def downcase_email
      email.downcase!
    end
end
