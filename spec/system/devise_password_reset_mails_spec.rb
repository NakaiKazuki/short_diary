require 'rails_helper'

RSpec.describe "DevisePasswordResetMails", type: :system do
  let(:user) { create(:user) }

  # リセット用のメールを送信してそのメールを開く

  before do
    ActionMailer::Base.deliveries.clear
    visit new_user_password_path
    fill_in "メールアドレス", with: user.email
    find(".form-submit").click
    open_email("user@example.com")
  end

  describe "パスワードリセットメール layout" do
    it "リンククリックでパスワードリセット用ページへ移動" do
      current_email.click_link "パスワードを変更する。"
      expect(page).to have_selector ".password-reset-edit-container"
    end
  end
end
