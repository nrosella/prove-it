require 'rails_helper'
include CapybaraHelper

describe 'User votes on a challenge in which they participate', :js => true do 
  it 'votes for themselves when submitting evidence second' do 
    user_one = FactoryGirl.create(:user)
    user_two = FactoryGirl.create(:user)
    two_users_submit_evidence(user_one,user_two)
    click_button "Vote for #{user_two.name.titleize}!"
    expect(page).to have_content "Thanks for voting!"
  end
    
  it 'votes for themselves when submitting evidence second' do 
    # working here 8/10
  end
end