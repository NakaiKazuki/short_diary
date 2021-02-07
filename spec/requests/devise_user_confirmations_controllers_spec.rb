require 'rails_helper'

RSpec.describe 'DeviseUsersConfirmationControllers', type: :request do
  let(:user) { create(:user) }

  # new
  describe 'GET /users/confirmation/new' do
    context 'ログアウト状態の場合' do
      before do
        get new_user_confirmation_path
      end

      it 'アクセス成功' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログイン状態の場合' do
      before do
        sign_in user
        get new_user_confirmation_path
        follow_redirect!
      end

      it '警告メッセージがある' do
        expect(flash[:alert]).to be_truthy
      end

      it 'ホーム画面に移動する' do
        expect(request.fullpath).to eq root_path
      end
    end
  end

  # create
  describe 'POST /users/confirmation' do
    context 'ログアウト状態の場合' do
      before do
        post user_confirmation_path
      end

      it 'アクセス成功' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログイン状態の場合' do
      before do
        sign_in user
        post user_confirmation_path
        follow_redirect!
      end

      it '警告メッセージがある' do
        expect(flash[:alert]).to be_truthy
      end

      it 'ホーム画面に移動する' do
        expect(request.fullpath).to eq root_path
      end
    end
  end

  # show
  describe 'GET /users/confirmation' do
    context 'ログアウト状態の場合' do
      before do
        get user_confirmation_path
      end

      it 'アクセス成功' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'ログイン状態の場合' do
      before do
        sign_in user
        get user_confirmation_path
        follow_redirect!
      end

      it '警告メッセージがある' do
        expect(flash[:alert]).to be_truthy
      end

      it 'ホーム画面に移動する' do
        expect(request.fullpath).to eq root_path
      end
    end
  end
end
