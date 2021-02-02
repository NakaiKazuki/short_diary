require 'rails_helper'

RSpec.describe 'DeviseRegistrationNews', type: :system do
  let(:user) { create(:user, :non_activate) }
  let(:activate_user) { create(:user) }

  # 有効な情報を保持したフォーム
  def submit_with_information(email: 'valid@example.com', password: 'password', password_confirmation: 'password')
    fill_in 'メールアドレス（例：email@example.com）', with: email
    fill_in 'パスワード（6文字以上）', with: password
    fill_in 'パスワード（再入力）', with: password_confirmation
    find('.form-submit').click
  end

  # 各項目が無効なパラメータ

  describe '/users/sign_up layout' do
    context 'ログアウト状態でアクセスした場合' do
      # 登録画面に移動
      before do
        visit new_user_registration_path
      end

      it '登録画面は表示される' do
        expect(page).to have_current_path new_user_registration_path,
                                          ignore_query: true
      end

      describe 'ページ内リンクの表示確認' do
        it 'ログインページへのリンク' do
          expect(page).to have_link 'アカウントをお持ちの方はこちら',
                                    href: new_user_session_path
        end

        it '認証メール再送信ページへのリンク' do
          expect(page).to have_link '再度認証メールを送信する方はこちら',
                                    href: new_user_confirmation_path
        end

        it '凍結解除メール再送信ページへのリンク' do
          expect(page).to have_link '再度凍結解除メールを送信する方はこちら',
                                    href: new_user_unlock_path
        end
      end

      context '無効なパラメータを送信した場合' do
        it '同じ画面が表示' do
          submit_with_information(email: 'invalid@example', password: 'foo', password_confirmation: 'bar')
          expect(title).to eq full_title('アカウント作成')
        end

        it 'エラーメッセージが表示' do
          submit_with_information(email: 'invalid@example', password: 'foo', password_confirmation: 'bar')
          expect(page).to have_selector '.alert-danger'
        end

        describe '各項目が無効な値の場合ユーザーは登録されない' do
          it '全項目が無効' do
            expect {
              submit_with_information(email: 'invalid@example', password: 'foo', password_confirmation: 'bar')
            }.to change(User, :count).by(0)
          end

          it 'メールアドレスが無効' do
            expect {
              submit_with_information(email: 'invalid@example')
            }.to change(User, :count).by(0)
          end

          it 'パスワードが無効' do
            expect {
              submit_with_information(password: 'foo')
            }.to change(User, :count).by(0)
          end

          it '確認用パスワードが無効' do
            expect {
              submit_with_information(password_confirmation: 'foo')
            }.to change(User, :count).by(0)
          end

          it 'パスワードと確認用パスワードの不一致は無効' do
            expect {
              submit_with_information(password_confirmation: 'mismatch_password_confirmation')
            }.to change(User, :count).by(0)
          end
        end
      end

      context '有効なパラメータを送信した場合' do
        it 'アカウント登録される' do
          expect {
            submit_with_information
          }.to change(User, :count).by(1)
        end

        describe 'アカウント登録に付随する処理' do
          it 'メールが送信される' do
            expect {
              submit_with_information
            }.to change { ActionMailer::Base.deliveries.size }.by(1)
          end

          it 'ホーム画面に移動' do
            submit_with_information
            expect(page).to have_current_path root_path, ignore_query: true
          end

          it 'アカウント有効化メール送信メッセージが表示' do
            submit_with_information
            expect(page).to have_selector '.alert-notice'
          end
        end
      end
    end

    context 'ログイン状態でアクセスした場合' do
      # ユーザーがログイン後登録画面に移動
      before do
        sign_in activate_user
        visit new_user_registration_path
      end

      it '登録画面は表示されない' do
        expect(page).to have_no_current_path new_user_registration_path,
                                             ignore_query: true
      end

      it '自動でホームへ移動' do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it '警告メッセージが表示' do
        expect(page).to have_selector '.alert-alert'
      end
    end
  end
end
