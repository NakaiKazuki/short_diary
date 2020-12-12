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
        expect(page).to have_link "アカウントを作成する", href: new_user_registration_path
      end

      it "ゲストとしてログインするボタンがある" do
        expect(page).to have_link "ゲストとしてログイン", href: users_guest_sign_in_path
      end

      it "ゲストとしてログインクリックでログイン" do
        click_link "ゲストとしてログイン", href: users_guest_sign_in_path
        expect(page).to have_link "Logout", href: destroy_user_session_path
      end
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

    describe "フォーム送信失敗後のurlで再読み込みした場合はホーム画面が表示" do
      context "/users の場合" do
        before do
          get users_path
        end

        it "アクセス可能" do
          expect(response).to have_http_status(:success)
        end
      end

      context "/users/password の場合" do
        before do
          get users_password_path
        end

        it "アクセス可能" do
          expect(response).to have_http_status(:success)
        end
      end

      context "/microposts の場合" do
        before do
          get microposts_path
        end

        it "アクセス可能" do
          expect(response).to have_http_status(:success)
        end
      end
    end
  end
end
