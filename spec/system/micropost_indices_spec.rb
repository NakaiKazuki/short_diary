require 'rails_helper'

RSpec.describe 'MicropostIndices', type: :system do
  let(:user) { create(:user) }
  let!(:micropost) { create(:micropost, :add_picture, user: user) }
  let(:favorite) { create(:favorite, user: user, micropost: micropost) }

  def submit_with_search_word(search_word)
    fill_in '日記の内容を入力してください', with: search_word
    find('.search-submit').click
  end

  describe 'microposts/_index layout' do
    before do
      sign_in user
      visit root_path
    end

    it '投稿日が表示' do
      expect(page).to have_selector '.micropost-date'
    end

    it '投稿内容が表示' do
      expect(page).to have_selector '.micropost-content'
    end

    it '投稿に付随した画像が表示' do
      expect(page).to have_selector '.micropost-picture'
    end

    it '投稿削除ボタンがある' do
      expect(page).to have_link 'Delete', href: micropost_path(micropost)
    end

    it '投稿削除成功メッセージが表示', js: true do
      expect {
        find_link('Delete', href: micropost_path(micropost)).click
        page.accept_confirm '選択した投稿を削除しますか？'
        expect(page).to have_selector '.alert-success'
      }.to change(Micropost, :count).by(-1)
    end

    describe '投稿内容検索機能' do
      it '検索した内容を含む投稿のみを表示' do
        submit_with_search_word(micropost.content)
        expect(page).to have_text micropost.content
      end

      it '検索ワードに当てはまらないものは表示されない' do
        submit_with_search_word('検索ワード')
        expect(page).not_to have_text micropost.content
      end
    end

    describe 'お気に入り登録機能' do
      it 'Favoriteデータが作成される', js: true do
        expect {
          click_button('Favorite')
        }.to change(Favorite, :count).by(1)
      end

      it 'お気に入り登録後ホーム画面が表示される' do
        click_button('Favorite')
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end

    describe 'お気に入り登録削除機能' do
      before do
        click_button('Favorite')
      end

      it 'お気に入りデータが削除される' do
        expect {
          click_button('Unfavorite')
        }.to change(Favorite, :count).by(-1)
      end

      it 'お気に入り削除後ホーム画面へ移動する' do
        click_button('Unfavorite')
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end
  end
end
