require 'rails_helper'

include CapybaraHelper
describe "Logging in", :js => true do
	it 'will visit the home page and log in an existing user' do 
		user = FactoryGirl.create(:user)
		login_user(user)
		expect(page).to have_content 'Logged in as'
	end
	
end