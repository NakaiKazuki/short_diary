require 'rails_helper'

RSpec.describe "DevisePasswordNews", type: :system do

  let(:user) { create(:user) }

  # メールアドレスが空白のため無効
  def submit_with_invalid_information
    fill_in "メールアドレス", with: " "
    find(".form-submit").click
  end

  # 登録されていないメールアドレス
  def submit_with_unregistered_email_information
    fill_in "メールアドレス", with: "invalid@email.com"
    find(".form-submit").click
  end

  def submit_with_valid_information
    fill_in "メールアドレス", with: user.email
    find(".form-submit").click
  end

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe "users/password/new layout" do
    context "ログアウト状態でアクセスした場合" do
      before do
        visit new_user_password_path
      end

      it "アクセス可能" do
        expect(current_path).to eq new_user_password_path
      end

      describe "ページ内のリンクの表示確認" do
        it "ログインページへのリンク" do
          expect(page).to have_link "アカウントをお持ちの方はこちら",href: new_user_session_path
        end

        it "アカウント登録ページへのリンク" do
          expect(page).to have_link "アカウントが無い方はこちら", href: new_user_registration_path
        end

        it "認証メール再送信ページへのリンク" do
          expect(page).to have_link "再度認証メールを送信する方はこちら", href: new_user_confirmation_path
        end

        it "凍結解除メール再送信ページへのリンク" do
          expect(page).to have_link "再度凍結解除メールを送信する方はこちら", href: new_user_unlock_path
        end
      end

      context "無効なパラメータを送信した場合" do
        it "エラーメッセージが表示" do
          submit_with_invalid_information
          expect(page).to have_selector ".alert-danger"
        end

        it "同じ画面が表示される" do
          submit_with_invalid_information
          expect(page).to have_selector ".password-reset-new-container"
        end

        describe "メールは送信されない" do
          it "メールアドレスが空" do
            expect {
              submit_with_invalid_information
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
          end

          it "登録されていないメールアドレス" do
            expect {
              submit_with_unregistered_email_information
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
          end
        end
      end

      context "有効なパラメータを送信した場合" do
        it "メールが送信" do
          expect {
            submit_with_valid_information
          }.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        it "メール送信メッセージが表示" do
          submit_with_valid_information
          expect(page).to have_selector ".alert-notice"
        end
      end
    end

    context "ログイン状態でアクセスした場合" do
      before do
        sign_in user
        visit new_user_password_path
      end

      it "ホーム画面へ移動" do
        expect(current_path).to eq root_path
      end

      it "警告メッセージが表示" do
        expect(page).to have_selector ".alert-alert"
      end
    end
  end
end
