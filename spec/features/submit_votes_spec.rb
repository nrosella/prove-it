require 'rails_helper'
include CapybaraHelper
include WaitForAjax

describe 'User votes on a challenge', :js => true do 
  it 'votes for themselves when submitting evidence second' do 
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
    click_link 'Capybara Test Challenge'
    attach_evidence
    click_button "Vote for #{user_two.name.capitalize}!"
    expect(page).to have_content "Thanks for voting!"
  end
end