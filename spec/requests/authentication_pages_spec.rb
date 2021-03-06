require 'spec_helper'

describe "AuthenticationPages" do
  
	subject { page }

	describe "sign in" do
		before { visit signin_path }

		it { should have_title "Sign In" }
		it { should have_content "Sign in" }

		describe "with invalid information" do
			before { click_button 'Sign in' }

			it { should have_selector('div.alert.alert-error', text: 'Invalid') }
			it { should have_title "Sign In" }
		end

		describe "with valid information" do
			let (:user) {FactoryGirl.create(:user) }
			before do
				fill_in "Email", 	with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"	
			end

			it { should have_title(user.name) }
			it { should have_link('Profile', 	 href: user_path(user)) }
			it { should have_link('Sign Out', 	 href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe "then sign out" do
				before { click_link "Sign Out" }
				it { should have_link "Sign In" }
			end
		end
	end
end
