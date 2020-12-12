require 'rails_helper'

RSpec.describe 'DeviseRegistrationEdits', type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { create(:user) }
  let(:guest) { create(:guest) }

  # 全てが無効なパラメータ
  def submit_with_invalid_information
    fill_in '新しいメールアドレス（例：email@example.com）', with: 'user@invalid'
    fill_in '新しいパスワード（6文字以上）', with: 'foo'
    fill_in '新しいパスワード（再入力）', with: 'bar'
    fill_in '使用中のパスワード', with: 'hogehoge'
    find('.form-submit').click
  end

  # 各項目が無効なパラメータ
  # メールアドレスが無効なパラメータ
  def submit_with_email_is_invalid_information
    fill_in '新しいメールアドレス（例：email@example.com）', with: 'user@invalid'
    fill_in '新しいパスワード（6文字以上）', with: 'foobar'
    fill_in '新しいパスワード（再入力）', with: 'foobar'
    fill_in '使用中のパスワード', with: user.password
    find('.form-submit').click
  end

  # メールアドレスが空白なパラメータ
  def submit_with_email_is_empty_information
    fill_in '新しいメールアドレス（例：email@example.com）', with: ''
    fill_in '新しいパスワード（6文字以上）', with: 'foobar'
    fill_in '新しいパスワード（再入力）', with: 'foobar'
    fill_in '使用中のパスワード', with: user.password
    find('.form-submit').click
  end

  # 使用中のパスワードが一致しないのパラメータ
  def submit_with_current_password_is_not_matching_information
    fill_in '新しいメールアドレス（例：email@example.com）', with: user.email
    fill_in '新しいパスワード（6文字以上）', with: 'foobar'
    fill_in '新しいパスワード（再入力）', with: 'foobar'
    fill_in '使用中のパスワード', with: 'not_matting_password'
    find('.form-submit').click
  end

  # 使用中のパスワードが空白のパラメータ
  def submit_with_current_password_is_empty_information
    fill_in '新しいメールアドレス（例：email@example.com）', with: user.email
    fill_in '新しいパスワード（6文字以上）', with: 'foobar'
    fill_in '新しいパスワード（再入力）', with: 'foobar'
    fill_in '使用中のパスワード', with: ''
    find('.form-submit').click
  end

  # 有効なパラメータ
  # 全て変更
  def submit_with_valid_information
    fill_in '新しいメールアドレス（例：email@example.com）', with: 'user@valid.com'
    fill_in '新しいパスワード（6文字以上）', with: 'foobar'
    fill_in '新しいパスワード（再入力）', with: 'foobar'
    fill_in '使用中のパスワード', with: user.password
    find('.form-submit').click
  end

  # メールアドレスのみを変更
  def submit_with_change_email_valid_information
    fill_in '新しいメールアドレス（例：email@example.com）', with: 'user@valid.com'
    fill_in '新しいパスワード（6文字以上）', with: ''
    fill_in '新しいパスワード（再入力）', with: ''
    fill_in '使用中のパスワード', with: user.password
    find('.form-submit').click
  end

  describe '/users/edit layout' do
    context 'ログアウト状態でアクセスした場合' do
      before do
        visit edit_user_registration_path
      end

      it '警告メッセージが表示' do
        expect(page).to have_selector '.alert-alert'
      end

      it 'ログイン画面へ移動' do
        expect(page).to have_current_path new_user_session_path,
                                          ignore_query: true
      end
    end

    context 'ログイン状態でアクセスした場合' do
      before do
        sign_in user
        visit edit_user_registration_path
      end

      it '登録情報編集画面は表示される' do
        expect(page).to have_current_path edit_user_registration_path,
                                          ignore_query: true
      end

      context '無効なパラメータを送信した場合' do
        it '同じ画面が表示' do
          submit_with_invalid_information
          expect(page).to have_selector '.user-edit-container'
        end

        it 'エラーメッセージが表示' do
          submit_with_invalid_information
          expect(page).to have_selector '.alert-danger'
        end

        it 'メールアドレスが無効の場合は確認用メールが送信されない' do
          expect do
            submit_with_email_is_invalid_information
          end.to change { ActionMailer::Base.deliveries.size }.by(0)
        end

        describe '各項目が無効な場合登録情報は変更されない' do
          it 'メールアドレスが無効なパラメータ' do
            submit_with_email_is_invalid_information
            expect(user.reload.email).to eq 'user@example.com'
          end

          it 'メールアドレスが空白なパラメータ' do
            submit_with_email_is_empty_information
            expect(user.reload.email).to eq 'user@example.com'
          end

          it '使用中のパスワードが一致しないパラメータ' do
            submit_with_current_password_is_not_matching_information
            expect(user.reload.email).to eq 'user@example.com'
          end

          it '使用中のパスワードが空白のパラメータ' do
            submit_with_current_password_is_empty_information
            expect(user.reload.email).to eq 'user@example.com'
          end
        end
      end

      context '有効なパラメータを送信した場合' do
        it 'メールアドレスを変更すると確認メールが送信される' do
          expect do
            submit_with_valid_information
          end.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        it 'ホーム画面へ移動' do
          submit_with_valid_information
          expect(page).to have_current_path root_path, ignore_query: true
        end

        it 'メール送信メッセージが表示' do
          submit_with_valid_information
          expect(page).to have_selector '.alert-notice'
        end

        it 'メールアドレスの変更は確認メールのリンククリック後変更' do
          submit_with_change_email_valid_information
          open_email('user@valid.com')
          current_email.click_link 'アカウントを有効化する'
          expect(user.reload.email).to eq 'user@valid.com'
        end
      end

      describe 'アカウント削除ボタン' do
        it 'アカウント削除ボタンがある' do
          expect(page).to have_button 'Delete Account'
        end

        it 'アカウント削除ボタンでアカウント削除', js: true do
          expect do
            find_button('Delete Account').click
            page.accept_confirm 'アカウントを削除してもよろしいですか？（投稿内容も全て削除されます）'
            expect(page).to have_selector '.alert-notice'
          end.to change(User, :count).by(-1)
        end

        it 'アカウント削除でログアウトされる', js: true do
          find_button('Delete Account').click
          page.accept_confirm 'アカウントを削除してもよろしいですか？（投稿内容も全て削除されます）'
          expect(page).to have_link 'Login', href: new_user_session_path
        end

        it 'アカウント削除メッセージが表示される', js: true do
          find_button('Delete Account').click
          page.accept_confirm 'アカウントを削除してもよろしいですか？（投稿内容も全て削除されます）'
          expect(page).to have_selector '.alert-notice'
        end
      end
    end

    context 'ゲストユーザーでログインした場合', js: true do
      before do
        sign_in guest
        visit edit_user_registration_path
      end

      it 'ゲストユーザーは削除できない' do
        expect do
          find_button('Delete Account').click
          page.accept_confirm 'アカウントを削除してもよろしいですか？（投稿内容も全て削除されます）'
        end.to change(User, :count).by(0)
      end

      it '削除実行後ホーム画面へ移動' do
        find_button('Delete Account').click
        page.accept_confirm 'アカウントを削除してもよろしいですか？（投稿内容も全て削除されます）'
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it 'アカウント削除しようとすると削除不可メッセージが表示' do
        find_button('Delete Account').click
        page.accept_confirm 'アカウントを削除してもよろしいですか？（投稿内容も全て削除されます）'
        expect(page).to have_selector '.alert-alert'
      end
    end
  end
end
