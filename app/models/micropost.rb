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
