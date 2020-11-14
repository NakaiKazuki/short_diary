require 'rails_helper'

RSpec.describe "StaticPageHomes", type: :system do
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

    end
  end
end
