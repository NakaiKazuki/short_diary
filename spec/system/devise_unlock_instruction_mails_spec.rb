require 'rails_helper'

RSpec.describe "DeviseUnlockInstructionMails", type: :system do
  let(:user) { create(:user) }

  # repeatの回数連続でパスワードが一致しないパラメータ送信
  def submit_with_consecutive_password_mismatches
    5.times{
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password_is_not_matching"
      find(".form-submit").click
     }
  end

  # アカウント凍結解除メールを送信して開いている
  before do
    ActionMailer::Base.deliveries.clear
    visit new_user_session_path
    submit_with_consecutive_password_mismatches
    open_email("user@example.com")
  end

  # 全て有効なログインパラメータ
  def submit_with_valid_information
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    find(".form-submit").click
  end

  describe "アカウント凍結解除メール layout" do
    it "凍結解除リンクがある" do
      expect(current_email).to have_link "アカウントの凍結を解除する"
    end

    context "凍結解除リンクを1度だけクッリクした場合" do
      before do
        current_email.click_link "アカウントの凍結を解除する"
      end

      it "ログイン画面へ移動" do
        expect(current_path).to eq new_user_session_path
      end

      it "凍結解除メッセージが表示" do
        expect(page).to have_selector ".alert-notice"
      end

      it "ログインが成功するようになる" do
        submit_with_valid_information
        expect(current_path).to eq root_path
      end
    end

    context "凍結解除リンクを2回クッリクした場合" do
      before do
        current_email.click_link "アカウントの凍結を解除する"
        current_email.click_link "アカウントの凍結を解除する"
      end

      it "凍結解除メール再送信ページが表示" do
        expect(current_path).to eq user_unlock_path
      end

      it "警告メッセージが表示" do
        expect(page).to have_selector ".alert-danger"
      end
    end
  end
end
