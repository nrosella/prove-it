require 'rails_helper'

describe "Signing up", :js => true do

	it 'will visit home page and sign up a new user' do 
		visit '/'
		click_link 'Sign up'

			fill_in 'Name', :with => 'Nino Rosella'
			fill_in 'Email', :with => "ninorosella@gmail.com"
			fill_in 'Password', :with => 'password123'
			fill_in 'Password Confirmation', :with => 'password123'
		
		click_button 'Sign up'
		expect(page).to have_content 'Logged in as'
	end
	
end


