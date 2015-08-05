class UsersController < ApplicationController

	def show
    if current_user
      @challenges = current_user.challenges
    else
      @user = User.find(params[:id])
      @challenges = @user.challenges.where.not(status: 'pending')
    end
		
	end

end