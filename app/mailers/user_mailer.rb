class UserMailer < ApplicationMailer

	def send_welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/#{user_path(@user)}"
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def send_invitation_email(user, challenge)
  	@user = user
    @url  = 'http://example.com/login'
    @challenge = challenge
    mail(to: @user.email, subject: "You've been challenged!")
  end

  def decline
    binding.pry
  end

end
