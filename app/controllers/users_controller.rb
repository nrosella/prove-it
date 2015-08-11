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
    @challenge_view_data = @user.doughnut_chart_challenge_data
    @challenge_view_data_options = @user.doughnut_chart_challenge_data_options
	end

  def edit
    @user = current_user
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(user_params)
    redirect_to user_path
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :bio, :avatar)
    end

end