require 'rails_helper'

RSpec.describe 'DeviseUnlockNews', type: :system do
  let(:user) { create(:user) }
  let(:freezing_user) { create(:user, :account_freeze) }

  # メールアドレスが空白のため無効
  def submit_with_invalid_information
    fill_in 'メールアドレス', with: ' '
    find('.form-submit').click
  end

  # メールアドレスが登録されていないため無効
  def submit_with_unregistered_email_information
    fill_in 'メールアドレス', with: 'invalid@email.com'
    find('.form-submit').click
  end

  # メールアドレス凍結されていないため無効
  def submit_with_unfrozen_email_address_information
    fill_in 'メールアドレス', with: user.email
    find('.form-submit').click
  end

  # 有効なメールアドレス
  def submit_with_valid_information
    fill_in 'メールアドレス', with: freezing_user.email
    find('.form-submit').click
  end

  describe '/users/unlock/new layout' do
    context 'ログアウト状態の場合' do
      before do
        visit new_user_unlock_path
      end

      it 'アクセス可能' do
        expect(page).to have_current_path new_user_unlock_path,
                                          ignore_query: true
      end

      describe 'ページ内のリンクの表示確認' do
        it 'ログインページへのリンク' do
          expect(page).to have_link 'アカウントをお持ちの方はこちら',
                                    href: new_user_session_path
        end

        it 'アカウント登録ページへのリンク' do
          expect(page).to have_link 'アカウントが無い方はこちら',
                                    href: new_user_registration_path
        end

        it 'パスワードリセットページへのリンク' do
          expect(page).to have_link 'パスワードを忘れた方はこちら',
                                    href: new_user_password_path
        end

        it '認証メール再送信ページへのリンク' do
          expect(page).to have_link '再度認証メールを送信する方はこちら',
                                    href: new_user_confirmation_path
        end
      end

      context '無効なパラメータを送信した場合' do
        it '同じ画面が表示' do
          submit_with_invalid_information
          expect(page).to have_selector '.unlock-container'
        end

        it 'エラーメッセージが表示' do
          submit_with_invalid_information
          expect(page).to have_selector '.alert-danger'
        end

        describe 'メールは送信されない' do
          it 'メールアドレスが空' do
            expect do
              submit_with_invalid_information
            end.to change { ActionMailer::Base.deliveries.size }.by(0)
          end

          it '登録されていないメールアドレス' do
            expect do
              submit_with_unregistered_email_information
            end.to change { ActionMailer::Base.deliveries.size }.by(0)
          end

          it '凍結されていないメールアドレス' do
            expect do
              submit_with_unfrozen_email_address_information
            end.to change { ActionMailer::Base.deliveries.size }.by(0)
          end
        end
      end

      context '有効なパラメータを送信した場合' do
        it 'メールが送信される' do
          expect do
            submit_with_valid_information
          end.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        it 'メール送信メッセージが表示' do
          submit_with_valid_information
          expect(page).to have_selector '.alert-notice'
        end
      end
    end

    context 'ログイン状態の場合' do
      before do
        sign_in user
        visit new_user_unlock_path
      end

      it '凍結解除メール再送信用画面は表示されない' do
        expect(page).to have_no_current_path new_user_unlock_path,
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
