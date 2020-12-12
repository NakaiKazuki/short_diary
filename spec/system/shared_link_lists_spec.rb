require 'rails_helper'

RSpec.describe 'SharedLinkLists', type: :system do
  let(:user) { create(:user) }

  describe 'shared/_link_list layout' do
    before do
      sign_in user
      visit root_path
    end

    it '登録情報編集ページへのリンクがある' do
      expect(page).to have_link '登録情報編集', href: edit_user_registration_path
    end
  end
end
