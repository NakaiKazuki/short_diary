require 'rails_helper'

RSpec.describe "DeviseLogins", type: :system do
  let(:user) { create(:user) }
  let(:non_activate) { create(:user,:non_activate) }
  # 全て無効なパラメータ
  def submit_with_invalid_information
    fill_in "メールアドレス", with: ""
    fill_in "パスワード", with: ""
    find(".form-submit").click
  end

  # メールアドレスが無効なパラメータ
  def submit_with_email_is_invalid_information
    fill_in "メールアドレス", with: " "
    fill_in "パスワード", with: user.password
    find(".form-submit").click
  end

  # パスワードが無効なパラメータ
  def submit_with_password_is_invalid_information
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "　"
    find(".form-submit").click
  end

  # メールアドレスに対してパスワードが一致しないパラメータ
  def submit_with_password_is_not_matching_information
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password_is_not_matching"
    find(".form-submit").click
  end

  # 全て有効なパラメータ
  def submit_with_valid_information(user)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    find(".form-submit").click
  end

  describe "/users/sign_in layout" do
    context "ログアウト状態でアクセスした場合" do
      # 共通処理としてログイン画面に移動
      before do
        visit new_user_session_path
      end

      describe "ページ内の要素の表示確認" do
        it "アカウント登録ページへのリンク" do
          expect(page).to have_link "アカウントが無い方はこちら", href: new_user_registration_path
        end

        it "パスワードリセットページへのリンク" do
          expect(page).to have_link "パスワードを忘れた方はこちら", href: new_user_password_path
        end

        it "認証メール再送信ページへのリンク" do
          expect(page).to have_link "再度認証メールを送信する方はこちら", href: new_user_confirmation_path
        end

        it "チェックボックス" do
          expect(page).to have_text "次からログインを省略する"
        end
      end

      context "無効なパラメータを送信した場合" do
        it "同じ画面が表示" do
          submit_with_invalid_information
          expect(page).to have_selector ".login-container"
        end

        describe "警告メッセージが表示" do
          it "全項目が無効" do
            submit_with_invalid_information
            expect(page).to have_selector ".alert-alert"
          end

          it "メールアドレスが無効" do
            submit_with_email_is_invalid_information
            expect(page).to have_selector ".alert-alert"
          end

          it "パスワードが無効" do
            submit_with_password_is_invalid_information
            expect(page).to have_selector ".alert-alert"
          end

          it "アドレスに対してパスワードの不一致は無効" do
            submit_with_password_is_not_matching_information
            expect(page).to have_selector ".alert-alert"
          end

          it "認証前のログインは無効" do
            submit_with_valid_information(non_activate)
            expect(page).to have_selector ".alert-alert"
          end
        end
      end

      context "有効なパラメータを送信した場合" do
        # 有効なパラメータを送信
        before  do
          submit_with_valid_information(user)
        end

        it "ホーム画面に移動する" do
          expect(current_path).to eq root_path
        end

        describe "ログイン完了メッセージが表示される" do
          it "ログイン完了メッセージを表示" do
            expect(page).to have_selector ".alert-notice"
          end

          it "ページ再表示でログイン完了メッセージ消滅" do
            visit new_user_session_path
            expect(page).not_to have_selector ".alert-notice"
          end
        end
      end
    end

    context "ログイン状態でアクセスした場合" do
      # ユーザーがログイン後登録画面に移動
      before do
        sign_in user
        visit new_user_session_path
      end

      it "登録画面は表示されない" do
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
end
