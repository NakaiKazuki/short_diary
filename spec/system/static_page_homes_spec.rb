require 'rails_helper'

RSpec.describe "StaticPageHomes", type: :system do
  let(:user) { create(:user) }
  describe "/ layout" do
    context "ログアウト状態でアクセスした場合" do
      # 共通処理としてホーム画面へ移動
      before do
        visit root_path
      end

      it "アカウント作成ページへのリンクがある" do
        expect(page).to have_link "アカウントを作成する",href: new_user_registration_path
      end

      # it "ゲストとしてログインするボタンがある" do
      #   expect(page).to have_link "ゲストとしてログイン",href: login_path
      # end
    end

    context "ログイン状態の場合" do
      before do
        sign_in user
        visit root_path
      end

      it "micropostのフォームがある" do
        expect(page).to have_selector ".micropost-form"
      end

      it "micropost一覧がある" do
        expect(page).to have_selector ".micropost-index"
      end

      it "リンク一覧がある" do
        expect(page).to have_selector ".link-list"
      end
    end
  end
end
