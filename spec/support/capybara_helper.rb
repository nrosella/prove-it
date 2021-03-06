module CapybaraHelper

  def login_user(user)
    visit '/'
    click_link 'Login'
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => user.password
    click_button 'Log in'
  end

  def create_challenge(user)
  	click_link 'Create a New Challenge'
		fill_in 'Title', :with => 'Capybara test challenge'
		fill_in 'Challenged email', :with => user.email
		fill_in 'Description', :with => 'A capybara description'
		click_button 'Create Challenge'
  end

  def logout_user
  	click_link 'Logout'
  end

  def accept_challenge
    click_link 'Profile'
    click_button 'Accept'
  end

  def attach_evidence
    image_path = Rails.root + 'evidence-samples/obama.jpg'
    attach_file('evidence_photo', image_path)
    click_button 'Submit evidence!'
  end

  def two_users_submit_evidence(user_one,user_two)
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
  end

end

