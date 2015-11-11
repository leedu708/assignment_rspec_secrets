require 'rails_helper'

describe User do

  let(:user) { build(:user) }

  it "is valid with name, email, password, and password confirmation" do
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user.name = nil
    expect(user).to be_invalid
  end

  it "is invalid without an email" do
    user.email = nil
    expect(user).to be_invalid
  end

  it "is valid with a name that is at least 3 characters" do
    user.name = "Foo"
    expect(user).to be_valid
  end

  it "is invalid with a name that is too short" do
    user.name = "Te"
    expect(user).to be_invalid
  end

  it "is invalid with a name that is too long" do
    user.name = "asdferqwerqwfaswqrewq"
    expect(user).to be_invalid
  end

  context "when saving users" do
    before do
      user.save!
    end

    it "invalid if email is already in use" do
      new_user = build(:user, :email => user.email)
      expect(new_user).to be_invalid
    end

  end

  it "accepts nil passwords" do
    user.password = ""
    user.password_confirmation = user.password
    expect(user).to be_valid
  end

  it "is valid with password of at least 6 chars" do
    user.password = "123456"
    user.password_confirmation = user.password
    expect(user).to be_valid
  end

  it "is invalid with password of less than 6 chars" do
    user.password = "12345"
    user.password_confirmation = user.password
    expect(user).to be_invalid
  end

  it "is invalid with password that is greater than 16 chars" do
    user.password = "12345678912345678"
    user.password_confirmation = user.password
    expect(user).to be_invalid
  end

  describe "Secrets Association" do

    it "responds to secrets association" do
      expect(user).to respond_to(:secrets)
    end

  end

end