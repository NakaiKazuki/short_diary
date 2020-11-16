require 'rails_helper'

RSpec.describe "AccountActivations", type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end

  def user_create
    visit new_user_registration_path
    fill_in "メールアドレス（例：email@example.com）", with: "user@example.com"
    fill_in "パスワード（6文字以上）", with: "password"
    fill_in "パスワード（再入力）", with: "password"
    find(".form-submit").click
  end
  describe "本登録用Email layout" do
    # 本登録用のメールを送信
    before do
      user_create
    end
  end
end
