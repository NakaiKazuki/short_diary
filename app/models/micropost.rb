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
class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :picture
  default_scope { order(created_at: :desc) }

  validates :content,
            presence: true,
            length: { maximum: 50 }
  validates :user_id,
            presence: true
  validate :validate_picture

  def resize_picture
    picture.variant(resize: '300x300').processed
  end

  # 画像の拡張子とサイズの制限をしている
  def validate_picture
    return unless picture.attached?

    if !picture.content_type.in?(%('image/jpeg image/jpg image/png image/gif'))
      errors.add(:picture, 'はjpeg, jpg, png, gif以外の投稿ができません')
    elsif picture.blob.byte_size > 5.megabytes
      errors.add(:picture, 'のサイズが5MBを超えています')
    end
  end
end
