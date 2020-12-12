require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    context 'ページタイトルが空の場合' do
      it 'ベースタイトルのみが表示される' do
        expect(helper.full_title).to eq('Short Diary')
      end
    end

    context 'ページタイトルが存在する場合' do
      it 'ページタイトル | ベースタイトルと表示される' do
        expect(helper.full_title('hoge')).to eq('hoge | Short Diary')
      end
    end
  end
end
