require 'rails_helper'

RSpec.describe "HomeMicropostForms", type: :system do
  let(:user) { create(:user) }

  # 無効なパラメータ
  def submit_with_invalid_information
    fill_in "50文字以内で今日の出来事を入力してください。", with: " "
    find(".form-submit").click
  end

  # 50文字超えるため無効なパラメータ
  def submit_with_content_is_51_characters_invalid_information
    fill_in "50文字以内で今日の出来事を入力してください。", with: "a" * 51
    find(".form-submit").click
  end

  # 6MBを超える画像ファイルが含まれるため無効なパラメータ
  def submit_with_invalid_information_add_6mb_picture
    fill_in "50文字以内で今日の出来事を入力してください。", with: "50文字以下の投稿"
    attach_file("spec/fixtures/images/test_6mb.jpg")
    find(".form-submit").click
  end

  # pdfファイルが含まれるため無効なパラメータ
  def submit_with_invalid_information_add_invalid_file
    fill_in "50文字以内で今日の出来事を入力してください。", with: "50文字以下の投稿"
    attach_file("spec/fixtures/images/test.pdf")
    find(".form-submit").click
  end

  # 有効なパラメータ
  def submit_with_valid_information
    fill_in "50文字以内で今日の出来事を入力してください。", with: "50文字以下の投稿"
    find(".form-submit").click
  end

  # 5MB以下の画像が追加された有効なパラメータ
  def submit_with_valid_information_when_add_picture
    fill_in "50文字以内で今日の出来事を入力してください。", with: "50文字以下の投稿"
    attach_file("spec/fixtures/images/test.jpg")
    find(".form-submit").click
  end

  describe "shared/_micropost_form layout" do
    before do
      sign_in user
      visit root_path
    end

    context "無効なパラメータを送信した場合" do
      it "同じページが表示" do
        submit_with_invalid_information
        expect(page).to have_selector ".micropost-form"
      end

      it "エラーメッセージが表示" do
        submit_with_invalid_information
        expect(page).to have_selector ".alert-danger"
      end

      describe "各項目が無効なパラメータだと投稿データは作成されない" do
        it "contentが空白" do
          expect{
            submit_with_invalid_information
          }.to change { Micropost.count }.by(0)
        end

        it "contentが51文字" do
          expect{
            submit_with_content_is_51_characters_invalid_information
          }.to change { Micropost.count }.by(0)
        end

        it "6MBを超える画像ファイルが含まれるため無効" do
          expect{
            submit_with_invalid_information_add_6mb_picture
          }.to change { Micropost.count }.by(0)
        end

        it "画像ファイル以外が含まれるため無効" do
          expect{
            submit_with_invalid_information_add_invalid_file
          }.to change { Micropost.count }.by(0)
        end
      end
    end

    context "有効なパラメータを送信した場合" do
      it "投稿が作成される" do
        expect{
          submit_with_valid_information
        }.to change { Micropost.count }.by(1)
      end

      it "5MB以下の画像の場合は投稿が作成される" do
        expect{
          submit_with_valid_information_when_add_picture
        }.to change { Micropost.count }.by(1)
      end

      describe "投稿作成完了に付随する処理" do
        before do
          submit_with_valid_information
        end

        it "ホーム画面に移動" do
          expect(current_path).to eq root_path
        end

        it "投稿完了メッセージが表示" do
          expect(page).to have_selector ".alert-success"
        end
      end
    end
  end
end
