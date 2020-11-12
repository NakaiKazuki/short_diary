require 'rails_helper'

RSpec.describe "DeviseLogins", type: :system do
  let(:user) { create(:user) }

  def submit_with_valid_information
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    find(".form-submit").click
  end
  def submit_with_email_is_invalid_information
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    find(".form-submit").click
  end
  describe "/users/sign_in" do
    # 共通処理としてログイン画面に移動

    before do
      visit new_user_session_path
    end

  end
end
