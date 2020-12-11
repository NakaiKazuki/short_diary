require 'rails_helper'

RSpec.describe "MicropostDestroys", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user, :other_email) }
  let!(:micropost) { create(:micropost,user: user) }

  describe "DLETE /microposts/:id" do
    context "ログイアウト状態の場合" do
      it "ログアウト時は無効" do
        expect {
          delete micropost_path(micropost)
        }.to change { Micropost.count }.by(0)
      end

      it "警告メッセージが表示" do
        delete micropost_path(micropost)
        expect(flash[:alert]).to be_truthy
      end

      it "ログイン画面へ移動" do
        delete micropost_path(micropost)
        follow_redirect!
        expect(request.fullpath).to eq new_user_session_path
      end
    end

    context "異なったユーザーでログインした場合" do
      before do
        sign_in other_user
        delete micropost_path(micropost)
      end

      it "ホーム画面へ移動" do
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end

    context "正しいユーザーでログインした場合" do
      before do
        sign_in user
      end

      it "投稿は削除される" do
        expect {
          delete micropost_path(micropost)
        }.to change { Micropost.count }.by(-1)
      end

      it "削除完了メッセージが表示" do
        delete micropost_path(micropost)
        expect(flash[:success]).to be_truthy
      end

      it "ホーム画面へ移動" do
        delete micropost_path(micropost)
        follow_redirect!
        expect(request.fullpath).to eq root_path
      end
    end
  end
end
