module ApplicationHelpers

# system specでログイン
  def login_by(user)
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    find(".form-submit").click
  end
end
