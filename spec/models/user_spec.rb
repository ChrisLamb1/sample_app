require 'spec_helper'

describe User do

  before { @user = User.new(name:"Chris",email:"chris@chris.com",password:"foobar",password_confirmation:"foobar") }
  subject { @user }
  it { should respond_to(:name)  }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should be_valid }

  describe "when name is blank" do
  	before { @user.name = "" }
  	it { should_not be_valid }
  end

  describe "when email is blank" do
  	before { @user.email = "" }
  	it { should_not be_valid  }
  end

  describe "when name is too long" do
  	before { @user.name = "a"*51 }
  	it { should_not be_valid }
  end

  describe "when email is too long" do
  	before { @user.email = "a"*51 }
  	it { should_not be_valid }
  end

  describe "when email is invalid" do
  	it "should be invalid" do
  	  addresses = %w[a@foo,com b_casdf@fart @fart.com a@b.c+m]
  	  addresses.each do |address|
  	  	@user.email = address
  	  	expect(@user).not_to be_valid
  	  end
  	end
  end

  describe "when email is valid" do
    it "should be valid" do
      addresses = %w[a.b@foo.com b_+cAAdf@fart.com AAA_B-C@fart.com a@b.co.uk]
      addresses.each do |address|
        @user.email = address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email is not unique" do
    before do
        user_two = @user.dup
        user_two.email = @user.email.upcase
        user_two.save
    end
    it { should_not be_valid }
  end

  describe "when passwords do not match" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password is blank" do
    before do
        @user.password = " "
        @user.password_confirmation = " "
    end
    it { should_not be_valid }
  end

  describe "when a password is too short" do
    before { @user.password = "a"}
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:user_found) {User.find_by(email:@user.email) }
    describe "with valid password" do
        it { should eq user_found.authenticate(@user.password)}
    end
    describe "with invalid password" do
        let(:invalid_user) { user_found.authenticate("invalid") }
        it { should_not eq invalid_user }
        specify { expect(invalid_user).to be_false }
    end
  end

  describe "remember_token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
