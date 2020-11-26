require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { create(:user)}
  let(:micropost) { user.microposts.build(content: "テストcontent", posted_date: Date.today, user_id: user.id)}

  describe "Micropost" do
    it "有効" do
      expect(micropost).to be_valid
    end

    it "投稿日が新しい投稿が最初に来る" do
      date =  Date.today
      create(:micropost, user: user, posted_date: date -3 )
      create(:micropost, user: user, posted_date: date -2 )
      create(:micropost, user: user, posted_date: date -1 )
      micropost_4 = create(:micropost,user: user, posted_date: date )
      expect(Micropost.first).to eq micropost_4
    end
  end

  describe "content" do
    it "空白は無効" do
      micropost.content = nil
      expect(micropost).to be_invalid
    end

    it "41文字以上は無効" do
      micropost.content = "a" * 41
      expect(micropost).to be_invalid
    end

    it "40文字以下は有効" do
      micropost.content = "a" * 40
      expect(micropost).to be_valid
    end
  end

  describe "posted_date" do
    it "空白は無効" do
      micropost.posted_date = nil
      expect(micropost).to be_invalid
    end

    it "有効" do
      micropost.posted_date = Date.today
      expect(micropost).to be_valid
    end
  end

  describe "user_id" do
    it "空白は無効" do
      micropost.user_id = nil
      expect(micropost).to be_invalid
    end

    it "有効" do
      micropost.user_id = user.id
      expect(micropost).to be_valid
    end
  end
end
