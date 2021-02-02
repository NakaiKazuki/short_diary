require 'rails_helper'

RSpec.describe 'DeviseConfirmationNews', type: :system do
  let(:activate_user) { create(:user) }
  let!(:non_activate) { create(:user, :non_activate, :other_email) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  # 有効な情報を保持したフォーム
  def submit_with_information(email = non_activate.email)
    fill_in '登録したメールアドレス', with: email
    find('.form-submit').click
  end

  describe '/users/confirmation/new layout' do
    context 'ログアウト状態でアクセスした場合' do
      before do
        visit new_user_confirmation_path
      end

      it 'アクセス可能' do
        expect(page).to have_current_path new_user_confirmation_path,
                                          ignore_query: true
      end

      describe 'ページ内リンクの表示確認' do
        it 'ログインページへのリンク' do
          expect(page).to have_link 'アカウントをお持ちの方はこちら',
                                    href: new_user_session_path
        end

        it 'パスワードリセットページへのリンク' do
          expect(page).to have_link 'パスワードを忘れた方はこちら',
                                    href: new_user_password_path
        end

        it '凍結解除メール再送信ページへのリンク' do
          expect(page).to have_link '再度凍結解除メールを送信する方はこちら',
                                    href: new_user_unlock_path
        end
      end

      context '無効なパラメータを送信した場合' do
        describe 'メールは送信されない' do
          it 'メールアドレスが空' do
            expect {
              submit_with_information(nil)
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
          end

          it 'すでに認証済みのメールアドレス' do
            expect {
              submit_with_information(activate_user.email)
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
          end

          it '未登録のメールアドレス' do
            expect {
              submit_with_information('unregistered@example.com')
            }.to change { ActionMailer::Base.deliveries.size }.by(0)
          end
        end

        it '警告メッセージが表示' do
          submit_with_information(nil)
          expect(page).to have_selector '.alert-danger'
        end
      end

      context '有効なパラメータ送信' do
        it 'メールが送信' do
          expect {
            submit_with_information
          }.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        it 'メール送信メッセージが表示' do
          submit_with_information
          expect(page).to have_selector '.alert-notice'
        end
      end
    end

    context 'ログイン状態でアクセスした場合' do
      before do
        sign_in activate_user
        visit new_user_confirmation_path
      end

      it 'ホーム画面へ移動' do
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it '警告メッセージが表示' do
        expect(page).to have_selector '.alert-alert'
      end
    end
  end
end
