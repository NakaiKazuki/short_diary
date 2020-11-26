require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { User.new(
    email: "user@example.com",
    password: "password",
    password_confirmation: "password"
  ) }

  describe "User" do
    it "有効" do
      expect(user).to be_valid
    end
  end

  describe "email" do
    it "空白は無効" do
      user.email = " "
      expect(user).to be_invalid
    end

    it "256文字以上は無効" do
      user.email = "a" * 244 + "@example.com"
      expect(user).to be_invalid
    end

    it "255文字以下は有効" do
      user.email = "a" * 243 + "@example.com"
      expect(user).to be_valid
    end

    describe "無効なアドレス" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@example..com]
      invalid_addresses.each do |invalid_address|
        it  "#{invalid_address}は無効" do
          user.email = invalid_address
          expect(user).to be_invalid
        end
      end
    end

    describe "有効なアドレス" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        it "#{valid_address}は有効" do
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end

    it "メールアドレスは一意" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end

    it "登録時は全て小文字" do
      user.email = "Foo@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq "foo@example.com"
    end
  end

  describe "password" do
    it "空白は無効" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
    end
    it "5文字以下は無効" do
      user.password = user.password_confirmation = "a" * 5
      expect(user).to be_invalid
    end

    it "6文字以上は有効" do
      user.password = user.password_confirmation = "a" * 6
      expect(user).to be_valid
    end
  end

  describe "アソシエーション" do
    before do
      user.save
      user.microposts.create(content: "アソシエーションのテスト",posted_date: Date.today)
    end

    it "アカウント削除で紐づいたMicropostデータ削除" do
      expect{
        user.destroy
      }.to change { Micropost.count }.by(-1)
    end
  end
end
