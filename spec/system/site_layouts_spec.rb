require 'rails_helper'

RSpec.describe "SiteLayouts", type: :system do
  describe "GET /" do
    it "ベースタイトルのみが表示されていること" do
      visit root_path
      expect(page).to have_title "Short Diary"
    end
  end
end
