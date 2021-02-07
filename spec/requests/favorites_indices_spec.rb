require 'rails_helper'

RSpec.describe 'FavoriteIndices', type: :request do
  let(:user) { create(:user) }

  describe 'GET /favorites' do
    context 'ログアウト状態の場合' do
      before do
        get favorites_path
        follow_redirect!
      end

      it '警告メッセージが表示' do
        expect(flash[:alert]).to be_truthy
      end

      it 'ログイン画面へ移動' do
        expect(request.fullpath).to eq new_user_session_path
      end
    end

    context 'ログイン状態の場合' do
      before do
        sign_in(user)
        get favorites_path
      end

      it 'アクセス成功' do
        expect(response).to have_http_status(:success)
      end
    end
  end
end
