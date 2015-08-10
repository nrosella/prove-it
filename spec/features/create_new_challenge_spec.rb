require 'rails_helper'
include CapybaraHelper

	describe "Creating a new challenge after sign in", :js => true do 
		it 'will visit the sign in home page and create a new challenge' do 
			user_one = FactoryGirl.create(:user)
			user_two = FactoryGirl.create(:user)
			login_user(user_one)
			create_challenge(user_two)
			expect(page).to have_content 'Status: pending'
		end
	
	end

	describe "Accept or decline a challenge" do 
		it "accepts a challenge" do 
			user_one = FactoryGirl.create(:user)
			user_two = FactoryGirl.create(:user)
			login_user(user_one)
			create_challenge(user_two)
			logout_user
			login_user(user_two)
			accept_challenge
			expect(page).to have_content 'Your In-Progress Challenges'
		end

		it "declines a challenge" do 
			user_one = FactoryGirl.create(:user)
			user_two = FactoryGirl.create(:user)
			login_user(user_one)
			create_challenge(user_two)
			logout_user
			login_user(user_two)
			click_link 'Profile'
			click_button 'Decline'
			fill_in 'Give a reason', :with => 'My reason'
			click_button 'Update Challenge'
			expect(page).to have_content 'Your Declined Challenges'
		end

	end