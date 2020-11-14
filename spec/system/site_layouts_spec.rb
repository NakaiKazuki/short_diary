require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "GET /" do
    let(:user) { create(:user) }

    # 共通
    it "ベースタイトルのみが表示されている" do
      visit root_path
      expect(page).to have_title "Short Diary"
    end
    context "ログアウト状態でアクセスした場合" do
      before do
        visit root_path
      end

      it "ログインページへのリンクがある" do
        expect(page).to have_link "Login" , href: new_user_session_path
      end

      it "ログアウトボタンはない" do
        expect(page).not_to have_link "Logout" , href: destroy_user_session_path
      end
    end

    context "ログイン状態でアクセスした場合" do
      before do
        sign_in user
        visit root_path
      end

      it "ログインページへのリンクはない" do
        expect(page).not_to have_link "Login" , href: new_user_session_path
      end
      describe "ログアウトボタンがある" do

        it "ログアウトボタンがある" do
          expect(page).to have_link "Logout" , href: destroy_user_session_path
        end

        it "クリックでログアウトメッセージ表示" do
          find_link("Logout").click
          expect(page).to have_selector ".alert-notice"
        end
      end
    end
  end
end
