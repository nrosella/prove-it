require 'rails_helper'

# describe "Logging in", :js => true do 

# 	# before :each do 
# 	# 	user = create(:user)
# 	# end

# 	it 'will visit the home page and log in an existing user' do 
# 		user = FactoryGirl.create(:user)
# 		visit '/'
# 		click_link 'Login'
# 		fill_in 'Email', :with => user.email
# 		fill_in 'Password', :with => user.password
# 		click_button 'Log in'
# 		expect(page).to have_content 'Logged in as'
# 	end

# end



describe "Signing up", :js => true do

	it 'will visit home page and sign up a new user' do 
		user = FactoryGirl.build(:user)
		visit '/'
		click_link 'Sign up'

			fill_in 'Name', :with => user.name
			fill_in 'Email', :with => user.email
			fill_in 'Password', :with => user.password
			fill_in 'Password Confirmation', :with => user.password
		
		click_button 'Sign up'
		expect(page).to have_content 'Logged in as'
	end

		it 'will visit the home page and log in an existing user' do 
		user = FactoryGirl.create(:user)
		visit '/'
		click_link 'Login'
		fill_in 'Email', :with => user.email
		fill_in 'Password', :with => user.password
		click_button 'Log in'
		expect(page).to have_content 'Logged in as'
	end
	
end