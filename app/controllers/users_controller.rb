class UsersController < ApplicationController

	def show
    if current_user
      @challenges = current_user.challenges
      @user = current_user
    else
      @user = User.find(params[:id])
      @challenges = @user.challenges.where.not(status: 'pending')
    end
	end

  def edit
    @user = current_user

  end

end