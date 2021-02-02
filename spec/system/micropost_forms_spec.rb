require 'rails_helper'

RSpec.describe 'MicropostForms', type: :system do
  let(:user) { create(:user) }

  # 有効な情報を保持したフォーム
  def submit_with_information(content = '50文字以下の投稿')
    fill_in '50文字以内で今日の出来事を入力してください。', with: content
    find('.form-submit').click
  end

  # 6MBの画像が追加された無効な情報
  def submit_with_information_add_6mb_picture
    fill_in '50文字以内で今日の出来事を入力してください。', with: '50文字以下の投稿'
    attach_file('spec/fixtures/images/test_6mb.jpg')
    find('.form-submit').click
  end

  # pdfファイルが追加された無効な情報
  def submit_with_information_add_pdf_file
    fill_in '50文字以内で今日の出来事を入力してください。', with: '50文字以下の投稿'
    attach_file('spec/fixtures/images/test.pdf')
    find('.form-submit').click
  end

  # 5MB以下の画像が追加された有効な情報
  def submit_with_valid_information_add_5mb_picture
    fill_in '50文字以内で今日の出来事を入力してください。', with: '50文字以下の投稿'
    attach_file('spec/fixtures/images/test.jpg')
    find('.form-submit').click
  end

  describe 'microposts/_form layout' do
    before do
      sign_in user
      visit root_path
    end

    context '無効なパラメータを送信した場合' do
      it '同じページが表示' do
        submit_with_information(nil)
        expect(page).to have_selector '.micropost-form'
      end

      it 'エラーメッセージが表示' do
        submit_with_information(nil)
        expect(page).to have_selector '.alert-danger'
      end

      describe '各項目が無効なパラメータだと投稿データは作成されない' do
        it 'contentが空白' do
          expect {
            submit_with_information(nil)
          }.to change(Micropost, :count).by(0)
        end

        it 'contentが51文字' do
          expect {
            submit_with_information('a' * 51)
          }.to change(Micropost, :count).by(0)
        end

        it '6MBを超える画像ファイルが含まれるため無効' do
          expect {
            submit_with_information_add_6mb_picture
          }.to change(Micropost, :count).by(0)
        end

        it '画像ファイル以外が含まれるため無効' do
          expect {
            submit_with_information_add_pdf_file
          }.to change(Micropost, :count).by(0)
        end
      end
    end

    context '有効なパラメータを送信した場合' do
      it '投稿が作成される' do
        expect {
          submit_with_information
        }.to change(Micropost, :count).by(1)
      end

      it '5MB以下の画像の場合は投稿が作成される' do
        expect {
          submit_with_valid_information_add_5mb_picture
        }.to change(Micropost, :count).by(1)
      end

      describe '投稿作成完了に付随する処理' do
        before do
          submit_with_information
        end

        it 'ホーム画面に移動' do
          expect(page).to have_current_path root_path, ignore_query: true
        end

        it '投稿完了メッセージが表示' do
          expect(page).to have_selector '.alert-success'
        end
      end
    end
  end
end
