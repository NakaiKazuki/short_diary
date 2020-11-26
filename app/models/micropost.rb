class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :picture
  default_scope { order(posted_date: :desc) }

  validates :content,
    presence: true,
    length: { maximum: 40 }
  validates :posted_date,
    presence: true
  validates :user_id,
    presence: true
  validate :validate_picture

  private
  #画像の拡張子とサイズの制限をしている
    def validate_picture
      if picture.attached?
        if !picture.content_type.in?(%('image/jpeg image/jpg image/png image/gif'))
          errors.add(:picture, 'はjpeg, jpg, png, gif以外の投稿ができません')
        elsif picture.blob.byte_size > 5.megabytes
          errors.add(:picture, "のサイズが5MBを超えています")
        end
      end
    end
end
