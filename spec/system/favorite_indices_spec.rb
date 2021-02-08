require 'rails_helper'

RSpec.describe 'FavoriteIndices', type: :system do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, :add_picture, user: user) }

  def submit_with_search_word(search_word)
    fill_in '日記の内容を入力してください', with: search_word
    find('.search-submit').click
  end

  describe '/favorites layout' do
    context 'ログアウト状態の場合' do
      before do
        visit favorites_path
      end

      it '警告メッセージが表示' do
        expect(page).to have_selector '.alert-alert'
      end

      it 'ログイン画面へ移動' do
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'ログイン状態の場合' do
      # お気に入り登録された投稿が1個ある状態でアクセス
      before do
        create(:favorite, user: user, micropost: micropost)
        sign_in user
        visit favorites_path
      end

      it '投稿日が表示' do
        expect(page).to have_selector '.fav_micropost-date'
      end

      it '投稿内容が表示' do
        expect(page).to have_selector '.fav_micropost-content'
      end

      it '投稿に付随した画像が表示' do
        expect(page).to have_selector '.fav_micropost-picture'
      end

      it 'お気に入り登録フォームが表示' do
        expect(page).to have_selector '.favorite-form'
      end

      it 'リンク一覧がある' do
        expect(page).to have_selector '.link-list'
      end

      describe 'お気に入り登録機能' do
        before do
          click_button('Unfavorite')
        end

        it 'Favoriteデータが作成される' do
          expect {
            click_button('Favorite')
          }.to change(Favorite, :count).by(1)
        end

        it 'お気に入り登録後ホーム画面が表示される', js: true do
          click_button('Favorite')
          expect(page).to have_current_path favorites_path, ignore_query: true
        end
      end

      describe 'お気に入り登録解除機能' do
        it 'お気に入りデータが削除される' do
          expect {
            click_button('Unfavorite')
          }.to change(Favorite, :count).by(-1)
        end

        it 'お気に入り削除後ホーム画面が表示される', js: true do
          click_button('Unfavorite')
          expect(page).to have_current_path favorites_path, ignore_query: true
        end
      end
    end
  end
end
