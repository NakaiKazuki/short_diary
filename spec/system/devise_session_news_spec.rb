require 'rails_helper'

RSpec.describe 'DeviseSessionNews', type: :system do
  let(:user) { create(:user) }
  let(:non_activate) { create(:user, :non_activate) }

  # 有効な情報を保持したフォーム
  def submit_with_information(email: user.email, password: user.password)
    fill_in 'メールアドレス', with: email
    fill_in 'パスワード', with: password
    find('.form-submit').click
  end

  # repeatの回数連続でパスワードが空白のパラメータ送信
  def submit_with_consecutive_password_empty(repeat)
    repeat.times do
      submit_with_information(password: nil)
    end
  end

  # repeatの回数連続でパスワードが一致しないパラメータ送信
  def submit_with_consecutive_password_mismatches(repeat)
    repeat.times do
      submit_with_information(password: 'mismatch_password')
    end
  end

  describe '/users/sign_in layout' do
    context 'ログアウト状態でアクセスした場合' do
      # 共通処理としてログイン画面に移動
      before do
        visit new_user_session_path
      end

      describe 'ページ内のリンクの表示確認' do
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

        it '凍結解除メール再送信ページへのリンク' do
          expect(page).to have_link '再度凍結解除メールを送信する方はこちら',
                                    href: new_user_unlock_path
        end

        it 'チェックボックス' do
          expect(page).to have_text '次からログインを省略する'
        end
      end

      context '無効なパラメータを送信した場合' do
        it '同じ画面が表示' do
          submit_with_information(email: nil, password: nil)
          expect(page).to have_selector '.login-container'
        end

        describe '警告メッセージが表示' do
          it '全項目が無効' do
            submit_with_information(email: nil, password: nil)
            expect(page).to have_selector '.alert-alert'
          end

          it 'メールアドレスが無効' do
            submit_with_information(email: nil)
            expect(page).to have_selector '.alert-alert'
          end

          it 'パスワードが無効' do
            submit_with_information(password: nil)
            expect(page).to have_selector '.alert-alert'
          end

          it 'アドレスに対してパスワードの不一致は無効' do
            submit_with_information(password: 'mismatch_password')
            expect(page).to have_selector '.alert-alert'
          end

          it '認証前のログインは無効' do
            submit_with_information(email: non_activate.email, password: non_activate.password)
            expect(page).to have_selector '.alert-alert'
          end
        end

        context '入力されたパスワードが複数回一致しない場合' do
          before do
            ActionMailer::Base.deliveries.clear
          end

          it 'パスワードが5連続空白の場合はメールは送信されない' do
            expect do
              submit_with_consecutive_password_empty(5)
            end.to change { ActionMailer::Base.deliveries.size }.by(0)
          end

          it '4連続入力失敗はメールが送信されない' do
            expect do
              submit_with_consecutive_password_mismatches(4)
            end.to change { ActionMailer::Base.deliveries.size }.by(0)
          end

          it '4連続入力失敗でアカウント凍結予告メッセージが表示' do
            submit_with_consecutive_password_mismatches(4)
            expect(page).to have_content 'もう一回誤るとアカウントがロックされます。'
          end

          it '5連続入力失敗でメールが送信される' do
            expect do
              submit_with_consecutive_password_mismatches(5)
            end.to change { ActionMailer::Base.deliveries.size }.by(1)
          end

          it '5連続入力失敗でアカウント凍結メッセージ表示' do
            submit_with_consecutive_password_mismatches(5)
            expect(page).to have_content 'アカウントは凍結されています。'
          end

          it 'アカウント凍結後は正しいパラメータでもログイン不可' do
            submit_with_consecutive_password_mismatches(5)
            submit_with_information
            expect(page).to have_content 'アカウントは凍結されています。'
          end
        end
      end

      context '有効なパラメータを送信した場合' do
        # 有効なパラメータを送信
        before do
          submit_with_information
        end

        it 'ホーム画面に移動' do
          expect(page).to have_current_path root_path, ignore_query: true
        end

        describe 'ログイン完了メッセージが表示される' do
          it 'ログイン完了メッセージを表示' do
            expect(page).to have_selector '.alert-notice'
          end

          it 'ページ再表示でログイン完了メッセージ消滅' do
            visit new_user_session_path
            expect(page).not_to have_selector '.alert-notice'
          end
        end
      end
    end

    context 'ログイン状態でアクセスした場合' do
      # ユーザーがログイン後登録画面に移動
      before do
        sign_in user
        visit new_user_session_path
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
