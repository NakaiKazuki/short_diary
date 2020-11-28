require 'rails_helper'

RSpec.describe "MicropostCreates", type: :request do
  let(:user) { create(:user) }

  # 全て無効なパラメータ
  def post_invalid_information
    post microposts_path,params:{
        micropost:{
        content: nil,
        posted_date: nil
      }
    }
  end

  # contentが無効なパラメータ
  def post_content_is_invalid_information
    post microposts_path,params:{
      micropost:{
        content: nil,
        posted_date: Date.today
      }
    }
  end

  # posted_dateが無効なパラメータ
  def post_posted_date_is_invalid_information
    post microposts_path,params:{
      micropost:{
        content: "テストcontent",
        posted_date: nil
      }
    }
  end

  # 有効なパラメータ
  def post_valid_information
    post microposts_path,params:{
      micropost:{
        content: "テストcontent",
        posted_date: Date.today
      }
    }
  end

  # 画像が追加された有効パラメータ
  def post_valid_information_add_picture
    post microposts_path,params:{
      micropost:{
        content: "テストcontent",
        posted_date: Date.today,
        picture: fixture_file_upload("images/test.jpg")
      }
    }
  end

  describe "Post /microposts" do
    context "ログアウト状態の場合" do
      it "ログアウト時は無効" do
        expect{
          post_valid_information
        }.to change { Micropost.count }.by(0)
      end

      it "警告メッセージが表示" do
        post_valid_information
        expect(flash[:alert]).to be_truthy
      end

      it "ログイン画面へ移動" do
        post_valid_information
        follow_redirect!
        expect(request.fullpath).to eq new_user_session_path
      end
    end

    context "ログイン状態の場合" do
      before do
        sign_in user
      end

      context "無効" do
        it "同じ画面が表示" do
          post_invalid_information
          expect(request.fullpath).to eq microposts_path
        end

        it "エラーメッセージが表示" do
          post_invalid_information
          micropost = controller.instance_variable_get(:@micropost)
          expect(micropost.errors).to be_of_kind(:content, :blank)
        end

        describe "各項目が無効なパラメータだと投稿データは作成されない" do
          it "全て無効" do
            expect{
              post_invalid_information
            }.to change { Micropost.count }.by(0)
          end

          it "contentが無効" do
            expect{
              post_content_is_invalid_information
            }.to change { Micropost.count }.by(0)
          end

          it "posted_dateが無効" do
            expect{
              post_posted_date_is_invalid_information
            }.to change { Micropost.count }.by(0)
          end
        end
      end

      context "有効" do
        it "有効なパラメータで投稿が作成" do
          expect{
            post_valid_information
          }.to change { Micropost.count }.by(1)
        end

        it "有効なパラメータで投稿が作成（画像追加）" do
          expect{
            post_valid_information_add_picture
          }.to change { Micropost.count }.by(1)
        end

        it "投稿作成完了メッセージ表示" do
          post_valid_information
          expect(flash[:success]).to be_truthy
        end
        it "ホーム画面へ移動" do
          post_valid_information
          follow_redirect!
          expect(request.fullpath).to eq root_path
        end
      end
    end
  end
end
