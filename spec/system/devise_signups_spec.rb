require 'rails_helper'

RSpec.describe "DeviseSignups", type: :system do
  # 全てが不正なパラメータ
  def submit_with_invalid_information
    fill_in "メールアドレス（例：email@example.com）", with: "user@invalid"
    fill_in "パスワード（6文字以上）", with: "foo"
    fill_in "パスワード（再入力）", with: "bar"
    find(".form-submit").click
  end

  # パスワードと確認用パスワードが一致しないパラメータ
  def submit_with_password_confirmation_is_not_matching_information
    fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード（再入力）", with: "foobar"
    find(".form-submit").click
  end

  # 各項目が不正なパラメータ
  # Emailが不正なパラメータ
    def submit_with_email_is_invalid_information
      fill_in "メールアドレス（例：email@example.com）", with: "user@invalid"
      fill_in "パスワード（6文字以上）", with: "password"
      fill_in "パスワード（再入力）", with: "password"
      find(".form-submit").click
    end

    # パスワードが不正なパラメータ
    def submit_with_password_is_invalid_information
      fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
      fill_in "パスワード（6文字以上）", with: "foo"
      fill_in "パスワード（再入力）", with: "password"
      find(".form-submit").click
    end

    # 確認用パスワードが不正なパラメータ
    def submit_with_password_confirmation_is_invalid_information
      fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
      fill_in "パスワード（6文字以上）", with: "password"
      fill_in "パスワード（再入力）", with: "pass"
      find(".form-submit").click
    end

  # 有効なパラメータ
  def submit_with_valid_information
    fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード（再入力）", with: "password"
    find(".form-submit").click
  end

  describe "/users/sign_up" do
    #共通処理としてユーザー登録画面に移動
    before do
      visit new_user_registration_path
    end

    context "パラメータが不正な場合" do
      it "不正なパラメータでは登録されない" do
        expect{
          submit_with_invalid_information
        }.to change { User.count }.by(0)
        expect(page).to have_selector ".alert-danger"
      end

      it "不正なパラメータを送信すると同じ画面が表示される" do
        submit_with_invalid_information
        expect(page).to have_selector ".signup-container"
      end

      it "不正なパラメータを送信するとエラーメッセージが表示される" do
        submit_with_invalid_information
        expect(page).to have_selector ".alert-danger"
      end

      it "パスワードと確認用パスワードが一致しない場合は無効" do
        expect{
          submit_with_password_confirmation_is_not_matching_information
        }.to change { User.count }.by(0)
      end

      context "各項目毎に不正なパラメータが存在する場合" do
        it "Emailが不正なパラメータは登録されない" do
          expect{
            submit_with_email_is_invalid_information
          }.to change { User.count }.by(0)
        end

        it "パスワードが不正なパラメータは登録されない" do
          expect{
            submit_with_password_is_invalid_information
          }.to change { User.count }.by(0)
        end

        it "確認用パスワードが不正なパラメータは登録されない" do
          expect{
            submit_with_password_confirmation_is_invalid_information
          }.to change { User.count }.by(0)
        end
      end
    end

    context "パラメータが有効な場合" do
      it "有効なパラメータは登録されること" do
        expect{
          submit_with_valid_information
        }.to change { User.count }.by(1)
      end

      it "登録後はホーム画面が表示されること" do
        submit_with_valid_information
        expect(current_path).to eq root_path
      end

      it "登録後は画面にログインメッセージが表示されること" do
        submit_with_valid_information
        expect(page).to have_selector ".alert-notice"
      end
    end
  end
end
