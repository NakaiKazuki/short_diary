require 'rails_helper'

RSpec.describe 'DeviseUserRegistrationsControllers', type: :request do
  let(:user) { create(:user) }
  let(:guest) { create(:guest) }

  describe 'DELETE /users' do
    context 'ゲスト以外のユーザーがアカウント削除を実行した場合' do
      before do
        sign_in user
      end

      it 'アカウントは削除される' do
        expect {
          delete user_registration_path
        }.to change(User, :count).by(-1)
      end
    end

    context 'ゲストユーザーがアカウント削除を実行した場合' do
      before do
        sign_in guest
      end

      it 'アカウントは削除されない' do
        expect {
          delete user_registration_path
        }.to change(User, :count).by(0)
      end

      it '警告メッセージが表示' do
        delete user_registration_path
        expect(flash[:alert]).to be_truthy
      end

      it 'ホーム画面へ移動' do
        delete user_registration_path
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end
  end
end
