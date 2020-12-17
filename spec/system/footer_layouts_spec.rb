require 'rails_helper'

RSpec.describe 'FooterLayouts', type: :system do
  describe '全画面共通' do
    before do
      visit root_path
    end

    it '製作者twitterのリンクがある' do
      expect(page).to have_link '製作者Twitter', href: 'https://twitter.com/k_kyube'
    end
  end
end
