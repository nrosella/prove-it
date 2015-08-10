require 'rails_helper'
include CapybaraHelper

describe 'Submitting evidence to an in-progress challenge', :js => true do 
	it 'creates a challenge and submits user_one evidence' do 
		user_one = FactoryGirl.create(:user)
		user_two = FactoryGirl.create(:user)
		login_user(user_one)
		create_challenge(user_two)
		logout_user
		login_user(user_two)
		accept_challenge
		click_link 'Capybara Test Challenge'
		image_path = Rails.root + 'evidence-samples/obama.jpg'
		attach_file('evidence_photo', image_path)
		click_button 'Submit evidence!'
		expect(page).to have_content "You've submitted evidence."
	end

end