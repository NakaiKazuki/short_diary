require 'rails_helper'

RSpec.describe 'MicropostCreates', type: :request do
  let(:user) { create(:user) }

  # 有効な情報を保持している
  def post_information(content = 'テストcontent')
    post microposts_path, params: {
      micropost: {
        content: content
      }
    }
  end

  # 画像が追加された有効パラメータ
  def post_information_add_picture
    post microposts_path, params: {
      micropost: {
        content: 'テストcontent',
        picture: Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/images/test.jpg'))
      }
    }
  end

  describe 'Post /microposts' do
    context 'ログアウト状態の場合' do
      it 'ログアウト時は無効' do
        expect {
          post_information
        }.to change(Micropost, :count).by(0)
      end

      it '警告メッセージが表示' do
        post_information
        expect(flash[:alert]).to be_truthy
      end

      it 'ログイン画面へ移動' do
        post_information
        follow_redirect!
        expect(request.fullpath).to eq new_user_session_path
      end
    end

    context 'ログイン状態の場合' do
      before do
        sign_in user
      end

      context '無効' do
        it '同じ画面が表示' do
          post_information(nil)
          expect(request.fullpath).to eq microposts_path
        end

        it 'エラーメッセージが表示' do
          post_information(nil)
          micropost = controller.instance_variable_get(:@micropost)
          expect(micropost.errors).to be_of_kind(:content, :blank)
        end

        it '各項目が無効なパラメータだと投稿データは作成されない' do
          expect {
            post_information(nil)
          }.to change(Micropost, :count).by(0)
        end
      end

      context '有効' do
        it '有効なパラメータで投稿が作成' do
          expect {
            post_information
          }.to change(Micropost, :count).by(1)
        end

        it '有効なパラメータで投稿が作成（画像追加）' do
          expect {
            post_information_add_picture
          }.to change(Micropost, :count).by(1)
        end

        it '投稿作成完了メッセージ表示' do
          post_information
          expect(flash[:success]).to be_truthy
        end

        it 'ホーム画面へ移動' do
          post_information
          follow_redirect!
          expect(request.fullpath).to eq root_path
        end
      end
    end
  end
end
