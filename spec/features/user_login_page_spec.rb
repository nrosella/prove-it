require 'rails_helper'

describe "Logging in", :js => true do 

	before :each do 
		user = create(:user)
	end

	it 'will visit the home page and log in an existing user' do 
		visit '/'
		click_link 'Login'
		fill_in 'Email', :with => 'nino@nino.com'
		fill_in 'Password', :with => 'password123'
		click_button 'Log in'
		expect(page).to have_content 'Logged in as'
	end

end