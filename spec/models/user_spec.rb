require "rails_helper"

RSpec.describe User, type: :model do
  # 有効なユーザーデータ
  let(:user) { create(:user)}

  describe "User" do
    it "有効" do
      expect(user).to be_valid
    end
  end

  describe "name" do
    it "空白は無効" do
      user.name = "  "
      expect(user).to be_invalid
    end

    it "51文字以上は無効" do
      user.name = "a" * 51
      expect(user).to be_invalid
    end

    it "50文字は有効" do
      user.name = "a" * 50
      expect(user).to be_valid
    end
  end

  describe "email" do
    it "空白は無効" do
      user.email = "  "
      expect(user).to be_invalid
    end

    it "256文字以上は無効" do
      user.email = "a" * 244 + "@example.com"
      expect(user).to be_invalid
    end

    it "255文字までは有効" do
      user.email =  "a" * 243 + "@example.com"
      expect(user).to be_valid
    end

    it "メールアドレスは一意" do
      # userをコピー
      duplicate_user = user.dup
      user.save!
      expect(duplicate_user).to be_invalid
    end

    it "登録するメールアドレスは全て小文字に変換" do
      user.email = "Foo@ExAMPle.CoM"
      user.save!
      expect(user.reload.email).to eq "foo@example.com"
    end

    describe "正規表現に一致しないメールアドレスは無効" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com foo@example..com]
      invalid_addresses.each do |invalid_address|
        it "無効なパスワード" do
          user.email = invalid_address
          expect(user).to be_invalid
        end
      end
    end

    describe "正規表現に一致するメールアドレスは有効" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                           first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
        it "有効なパスワード" do
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end
  end

  describe "passwordとpassword_confirmation" do
    it "空白のパスワードは無効" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to be_invalid
    end

    it "5文字以下のパスワードは短いため無効" do
      user.password = user.password_confirmation = "a" * 5
      expect(user).to be_invalid
    end

    it "６文字以上は有効なパスワード" do
      user.password = user.password_confirmation = "a" * 6
      expect(user).to be_valid
    end
  end
end
