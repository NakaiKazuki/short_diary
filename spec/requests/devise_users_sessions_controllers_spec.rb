require 'rails_helper'

RSpec.describe 'DeviseUsersSessionsControllers', type: :request do
  describe 'POST /users/guest_sign_in' do
    before do
      post users_guest_sign_in_path
    end

    it 'ログインメッセージがある' do
      expect(flash[:notice]).to be_truthy
    end

    it 'ホーム画面へ移動' do
      follow_redirect!
      expect(request.fullpath).to eq root_path
    end

    it 'ゲストアカウントとしてログインされている' do
      user = controller.instance_variable_get(:@user)
      expect(user.email).to eq 'guest@example.com'
    end
  end
end
