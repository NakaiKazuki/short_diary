class User < ApplicationRecord
# 保存前にメールアドレスを全て小文字に変更
 before_save :downcase_email
  # メールアドレス正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

 validates :name,
  # 空の値は保存不可
  presence: true,
  # 最大文字数を指定
  length: { maximum: 50 }
 validates :email,
  # 空の値は保存不可
  presence: true,
  # 最大文字数指定
  length: { maximum: 255 },
  # 正規表現を指定
  format: { with: VALID_EMAIL_REGEX },
  # 一意性とメールアドレスの大文字・小文字の区別を無くしている
  uniqueness: { case_sensitive: false }
has_secure_password
validates :password,
  # 空の値は保存不可
  presence: true,
  # 最大文字数指定
  length: { minimum: 6 }

  private
    # メールアドレスを小文字化
    def downcase_email
      email.downcase!
    end
end
