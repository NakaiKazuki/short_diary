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

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user: user) }
  let(:favorite) { create(:favorite, user: user, micropost: micropost) }

  describe 'Favorite' do
    it '有効' do
      expect(favorite).to be_valid
    end

    describe '無効' do
      it 'user_idが空は無効' do
        favorite.user_id = nil
        expect(favorite).to be_invalid
      end

      it 'micropost_idが空は無効' do
        favorite.micropost_id = nil
        expect(favorite).to be_invalid
      end

      it 'user_idとmicropost_idの組み合わせは一意' do
        dup_favorite = favorite.dup
        expect(dup_favorite).to be_invalid
      end
    end
  end

  describe 'アソシエーション' do
    before do
      favorite.save
    end

    it '関連するUserデータ削除と同時に削除' do
      expect {
        user.destroy
      }.to change(Favorite, :count).by(-1)
    end

    it '関連するMicropostデータ削除と同時に削除' do
      expect {
        micropost.destroy
      }.to change(Favorite, :count).by(-1)
    end
  end
end
