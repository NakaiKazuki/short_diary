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
require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { user.microposts.build(content: 'テストcontent', user: user) }

  describe 'Micropost' do
    it '有効' do
      expect(micropost).to be_valid
    end

    it '投稿日が新しい投稿が最初に来る' do
      date = Time.zone.today
      create(:micropost, user: user, created_at: date - 3)
      create(:micropost, user: user, created_at: date - 2)
      create(:micropost, user: user, created_at: date - 1)
      micropost4 = create(:micropost, user: user, created_at: date)
      expect(Micropost.first).to eq micropost4
    end
  end

  describe 'content' do
    it '空白は無効' do
      micropost.content = nil
      expect(micropost).to be_invalid
    end

    it '51文字以上は無効' do
      micropost.content = 'a' * 51
      expect(micropost).to be_invalid
    end

    it '50文字以下は有効' do
      micropost.content = 'a' * 50
      expect(micropost).to be_valid
    end
  end

  describe 'user_id' do
    it '空白は無効' do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end

    it '有効' do
      micropost.user_id = user.id
      expect(micropost).to be_valid
    end
  end

  describe 'picture' do
    it '5mbより大きいファイルは無効' do
      micropost.picture.attach(io: File.open(Rails.root.join('spec/fixtures/images/test_6mb.jpg')),
                               filename: 'test_6mb.jpg', content_type: 'image/jpg')
      expect(micropost).to be_invalid
    end

    it '画像ファイル以外は無効' do
      micropost.picture.attach(io: File.open(Rails.root.join('spec/fixtures/images/test.pdf')),
                               filename: 'test.pdf', content_type: 'application/pdf')
      expect(micropost).to be_invalid
    end

    it '5mb以下の画像ファイルは有効' do
      micropost.picture.attach(io: File.open(Rails.root.join('spec/fixtures/images/test.jpg')),
                               filename: 'test.jpg', content_type: 'image/jpg')
      expect(micropost).to be_valid
    end
  end
end
