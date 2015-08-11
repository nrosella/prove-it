class UsersController < ApplicationController

	def show
    if current_user
      @challenges = current_user.challenges
      @user = current_user
    else
      @user = User.find(params[:id])
      @challenges = @user.challenges.where.not(status: 'pending')
    end
    @user = current_user
    @challenge_chart_data = @user.doughnut_chart_data
    @challenge_chart_options = @user.doughnut_chart_options
    @challenge_participation_chart = @user.participation_chart
	end

  def edit
    @user = current_user 
  end

end