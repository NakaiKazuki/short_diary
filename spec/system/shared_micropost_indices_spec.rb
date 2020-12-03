require 'rails_helper'

RSpec.describe "SharedMicropostIndices", type: :system do
  let(:user) { create(:user) }
  let!(:micropost) { create(:micropost,:add_picture,user:user) }

  describe "shared/_micropost_index layout" do
    before do
      sign_in user
      visit root_path
    end

    it "投稿日が表示" do
      expect(page).to have_selector ".micropost-date"
    end

    it "投稿内容が表示" do
      expect(page).to have_selector ".micropost-content"
    end

    it "投稿に付随した画像が表示" do
      expect(page).to have_selector ".micropost-picture"
    end
    
    it "投稿削除ボタンがある" do
      expect(page).to have_link "削除", href: micropost_path(micropost)
    end

    it "投稿削除成功メッセージが表示", js:true do
      expect{
        find_link("削除", href: micropost_path(micropost)).click
        page.accept_confirm "選択した投稿を削除しますか？"
        expect(page).to have_selector ".alert-success"
      }.to change { Micropost.count }.by(-1)
    end
  end
end
