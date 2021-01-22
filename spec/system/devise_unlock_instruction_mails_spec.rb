require 'rails_helper'

RSpec.describe 'DeviseUnlockInstructionMails', type: :system do
  let(:user) { create(:user) }

  # アカウント凍結解除メールを送信して開いている
  before do
    ActionMailer::Base.deliveries.clear
    visit new_user_session_path
    5.times do
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: 'password_is_not_matching'
      find('.form-submit').click
    end
    open_email('user@example.com')
  end

  # 有効な情報を保持したフォーム
  def submit_with_valid_information
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    find('.form-submit').click
  end

  describe 'アカウント凍結解除メール layout' do
    it '凍結解除リンクがある' do
      expect(current_email).to have_link 'アカウントの凍結を解除する'
    end

    context '凍結解除リンクを1度だけクッリクした場合' do
      before do
        current_email.click_link 'アカウントの凍結を解除する'
      end

      it 'ログイン画面へ移動' do
        expect(page).to have_current_path new_user_session_path,
                                          ignore_query: true
      end

      it '凍結解除メッセージが表示' do
        expect(page).to have_selector '.alert-notice'
      end

      it 'ログインが成功するようになる' do
        submit_with_valid_information
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end

    context '凍結解除リンクを2回クッリクした場合' do
      before do
        current_email.click_link 'アカウントの凍結を解除する'
        current_email.click_link 'アカウントの凍結を解除する'
      end

      it '凍結解除メール再送信ページが表示' do
        expect(page).to have_current_path user_unlock_path, ignore_query: true
      end

      it 'エラーメッセージが表示' do
        expect(page).to have_selector '.alert-danger'
      end
    end
  end
end
