require 'rails_helper'

RSpec.describe "DevisePasswordEdits", type: :system do
  let(:user) { create(:user) }

  #　全てが無効なパラメータ
  def submit_with_invalid_information
    fill_in "パスワード（6文字以上）", with: ""
    fill_in "パスワード（再入力）", with: ""
    find(".form-submit").click
  end

  #各項目が無効なパラメータ
    # パスワードが無効なパラメータ
    def submit_with_password_is_invalid_information
      fill_in "パスワード（6文字以上）", with: "foo"
      fill_in "パスワード（再入力）", with: "foobar"
      find(".form-submit").click
    end

    # 確認用パスワードが無効なパラメータ
    def submit_with_password_confirmation_is_invalid_information
      fill_in "パスワード（6文字以上）", with: "foobar"
      fill_in "パスワード（再入力）", with: "foo"
      find(".form-submit").click
    end

    # パスワードと確認用パスワードが一致しないパラメータ
    def submit_with_password_confirmation_is_invalid_information
      fill_in "パスワード（6文字以上）", with: "foobar"
      fill_in "パスワード（再入力）", with: "hogehoge"
      find(".form-submit").click
    end

  # 有効なパラメータ
  def submit_with_valid_information
    fill_in "パスワード（6文字以上）", with: "success"
    fill_in "パスワード（再入力）", with: "success"
    find(".form-submit").click
  end

  # パスワード変更メールを開く
  before do
    ActionMailer::Base.deliveries.clear
  end

  context "メールのリンクを経由せずにアクセスした場合" do
    before do
      edit_user_password_path
    end

    it "パスワード変更画面は表示されない" do
      expect(current_path).not_to eq new_user_registration_path
    end
  end

  context "ログアウト状態でアクセスした場合" do
    before do
      visit new_user_password_path
      fill_in "メールアドレス", with: user.email
      find(".form-submit").click
      open_email("user@example.com")
      current_email.click_link "パスワードを変更する。"
    end

    it "アクセス可能" do
      expect(page).to have_selector ".password-reset-edit-container"
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
        expect(page).to have_selector ".password-reset-edit-container"
      end

      describe "各項目が無効な場合パスワードは変更されない" do
        it "パスワードが無効" do
          submit_with_password_is_invalid_information
          expect(user.reload.password).to eq "password"
        end

        it "確認用パスワードが無効" do
          submit_with_password_confirmation_is_invalid_information
          expect(user.reload.password).to eq "password"
        end

        it "パスワードと確認用パスワードの不一致は無効" do
          submit_with_password_confirmation_is_invalid_information
          expect(user.reload.password).to eq "password"
        end
      end
    end

    context "有効なパラメータを送信した場合" do
      before do
        submit_with_valid_information
      end

      it "変更成功メッセージが表示" do
        expect(page).to have_selector ".alert-notice"
      end

      it "ホーム画面へ移動" do
        expect(current_path).to eq root_path
      end

      # sessionの情報を利用して確認したいけど、わからないからログアウトボタンがあるかで代用
      it "ログインされている" do
        expect(page).to have_link "Logout", href: destroy_user_session_path
      end
    end
  end

  context "ログイン状態でアクセスした場合" do
    before do
      visit new_user_password_path
      fill_in "メールアドレス", with: user.email
      find(".form-submit").click
      sign_in user
      open_email("user@example.com")
      current_email.click_link "パスワードを変更する。"
    end

    it "パスワード変更画面は表示されない" do
      expect(current_path).not_to eq new_user_registration_path
    end

    it "自動でホームへ移動" do
      expect(current_path).to eq root_path
    end

    it "警告メッセージが表示" do
      expect(page).to have_selector ".alert-alert"
    end
  end
end
