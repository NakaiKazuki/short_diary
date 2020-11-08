require 'rails_helper'

RSpec.describe "StaticPageHomes", type: :system do
  context "非ログイン状態" do
    # ホーム画面へアクセス
    before do
      visit root_path
    end

    it "アカウント作成ページへのリンクがある" do
      expect(page).to have_link "アカウントを作成する",href: signup_path
    end

    it "ゲストとしてログインするボタンがある" do
      expect(page).to have_link "ゲストとしてログイン",href: login_path
    end
  end
end
