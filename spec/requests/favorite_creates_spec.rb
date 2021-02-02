require 'rails_helper'

RSpec.describe 'FavoriteCreates', type: :request do
  let(:user) { create(:user) }
  let(:micropost) { create(:micropost, user: user) }

  describe 'POST /microposts/:id/favorites' do
    context 'ログアウト状態の場合' do
      it 'ログアウト時は無効' do
        expect {
          post favorites_path(micropost_id: micropost)
        }.to change(Favorite, :count).by(0)
      end

      it '警告メッセージが表示' do
        post favorites_path(micropost_id: micropost)
        expect(flash[:alert]).to be_truthy
      end

      it 'ログイン画面へ移動' do
        post favorites_path(micropost_id: micropost)
        follow_redirect!
        expect(request.fullpath).to eq new_user_session_path
      end
    end

    context 'ログイン状態の場合' do
      before do
        sign_in user
      end

      it 'ログインしている場合は有効' do
        expect {
          post favorites_path(micropost_id: micropost)
        }.to change(Favorite, :count).by(1)
      end

      it 'ホーム画面へ移動' do
        post favorites_path(micropost_id: micropost)
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end
  end
end
