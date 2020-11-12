require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  describe "GET /" do
    it "ホーム画面には誰でもアクセス可能" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
