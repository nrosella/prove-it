require 'rails_helper'
include CapybaraHelper

describe 'Submitting evidence to an in-progress challenge', :js => true do 
	it 'creates a challenge and submits one users evidence' do 
		user_one = FactoryGirl.create(:user)
		user_two = FactoryGirl.create(:user)
		login_user(user_one)
		create_challenge(user_two)
		logout_user
		login_user(user_two)
		accept_challenge
		click_link 'Capybara Test Challenge'
		attach_evidence
		expect(page).to have_content "Your evidence"
	end

	it 'creates a challenge and submits evidence for both users' do 
		user_one = FactoryGirl.create(:user)
		user_two = FactoryGirl.create(:user)
		login_user(user_one)
		create_challenge(user_two)
		logout_user
		login_user(user_two)
		accept_challenge
		click_link 'Capybara Test Challenge'
		attach_evidence
		logout_user
		login_user(user_one)
		click_link 'Profile'
		click_link 'Capybara Test Challenge'
		attach_evidence
		expect(page).to have_content "Status: voting"
	end



end