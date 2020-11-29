require 'rails_helper'

RSpec.describe "DeviseAccountActivationMails", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  def user_create
    visit new_user_registration_path
    fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード（再入力）", with: "password"
    find(".form-submit").click
  end

  describe "アカウント有効化メール layout" do
    # 本登録用のメールを送信しメールを開く
    before do
      user_create
      open_email("user@example.com")
    end

    context "1回だけメール内の確認するをクリックした場合" do
      before do
        current_email.click_link "アカウントを有効化する"
      end

      it "ログイン画面が表示" do
        expect(current_path).to eq new_user_session_path
      end

      it "メールアドレス確認完了メッセージが表示" do
        expect(page).to have_selector ".alert-notice"
      end
    end

    context "2回確認するをクリックした場合" do
      before do
        current_email.click_link "アカウントを有効化する"
        current_email.click_link "アカウントを有効化する"
      end

      it "tokenを利用した確認メール再送信用ページが表示される" do
        expect(current_path).to eq user_confirmation_path
      end

      it "エラーメッセージが表示される" do
        expect(page).to have_selector ".alert-danger"
      end
    end
  end
end
