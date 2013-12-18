FactoryGirl.define do	
	factory :user do
		name 		"Chris Lamb"
		email 		"something@random.org"
		password	"foobar"
		password_confirmation	"foobar"
	end
end