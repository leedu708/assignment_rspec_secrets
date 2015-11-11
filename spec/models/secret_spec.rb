require 'rails_helper'

describe Secret do

  let (:secret) { build(:secret) }

  it "is valid with author, title, and body" do
    expect(secret).to be_valid
  end

  it "is invalid without a title" do
    secret.title = nil
    expect(secret).to be_invalid
  end

  it "is invalid without a body" do
    secret.body = nil
    expect(secret).to be_invalid
  end

  it "is invalid without an author" do
    secret.author = nil
    expect(secret).to be_invalid
  end

  it "is valid with a title between 4 and 24 chars" do
    secret.title = "Yolo"
    expect(secret).to be_valid
  end

  it "is invalid with a title fewer than 4 chars" do
    secret.title = "num"
    expect(secret).to be_invalid
  end

  it "is invalid with a title greater than 24 chars" do
    secret.title = "num123num123num123num123n"
    expect(secret).to be_invalid
  end

  it "is valid with a body between 4 and 140 chars" do
    secret.body = "num1"
    expect(secret).to be_valid
  end

  it "is invalid with a body fewer than 4 chars" do
    secret.body = "num"
    expect(secret).to be_invalid
  end

  it "is invalid with a body greater than 140 chars" do
    secret.body = ""
    141.times { secret.body << "1" }
    expect(secret).to be_invalid
  end

  describe "#last_five" do

    it "returns 5 secrets if database has greater than or more than 5 secrets" do
      5.times { create(:secret) }
      expect(Secret.last_five.count).to be(5)
    end

    it "returns the number of secrets in the database if there are fewer than 5 secrets" do
      4.times { create(:secret) }
      expect(Secret.last_five.count).to be(4)
    end

  end

  describe "Author Association" do

    it "responds to author association" do
      expect(secret).to respond_to(:author)
    end

    it "is valid if the author is valid" do
      author = create(:user)
      secret.author = author
      expect(secret).to be_valid
    end

    it "is invalid if there is no author" do
      secret.author_id = 1000000
      expect(secret).to be_invalid
    end

  end

end