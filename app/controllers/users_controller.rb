class UsersController < ApplicationController

	def show
    if current_user
      @challenges = current_user.challenges
    else
      @user = User.find(params[:id])
      @challenges = @user.challenges.where.not(status: 'pending')
    end
    @user = current_user
    @challenge_view_data = @user.doughnut_chart_challenge_data
    @challenge_view_data_options = @user.doughnut_chart_challenge_data_options
	end

end