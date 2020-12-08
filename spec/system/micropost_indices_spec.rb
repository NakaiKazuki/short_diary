require 'rails_helper'

RSpec.describe "MicropostIndices", type: :system do
  let!(:user) { create(:user) }

  describe "GET /microposts layout" do
    context "ログアウト状態の場合" do
      before do
        visit microposts_path
      end

      it "警告メッセージが表示" do
        expect(page).to have_selector ".alert-alert"
      end

      it "ログイン画面へ移動" do
        expect(current_path).to eq new_user_session_path
      end
    end

    context "ログイン状態の場合" do
      before do
        sign_in user
        visit microposts_path
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
