require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup Page" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    it { should have_title(full_title "Sign Up") }
    it { should have_content("Sign Up") }

    describe "with valid information" do
      before do 
        fill_in "Name",             with: "Chris Lamb"
        fill_in "Email",            with: "something@example.org"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_title "Sign Up" }
        it { should have_content "error" }

        describe "with one error" do
          before do 
            fill_in "Email",            with: "something@example.com"
            fill_in "Password",         with: "foobar"
            fill_in "Confirm Password", with: "foobar"
            click_button submit 
          end

          it { should have_content "1" }
        end

        describe "with multiple errors" do 
          it { should have_content "5" }
        end
      end
    end

  end

  describe "profile page" do
  	let (:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user) }
  	it { should have_content(user.name) }
  	it { should have_title(user.name) }
  end
end
