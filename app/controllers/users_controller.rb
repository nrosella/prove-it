class UsersController < ApplicationController

	def show
    Challenge.update_status
    @user = User.find(params[:id])
    @challenges = @user.challenges
    @user_in_progress = @challenges.where(status: 'in_progress')
    @user_in_voting = @challenges.where(status: 'voting')
    @challenge_chart_data = @user.doughnut_chart_data
    @challenge_chart_options = @user.doughnut_chart_options
    @challenge_participation_chart = @user.participation_chart
	end

  def edit
    @user = current_user 
  end

  def update
    user = User.find(params[:id])
    user.update_attributes(user_params)
    redirect_to user_path
  end


  def victories
    @user = User.find(params[:id])
  end

  def defeats
    @user = User.find(params[:id])
  end

  def declined
    @user = User.find(params[:id])
  end

  def trophies
    
    @user = current_user
    @trophies = @user.trophies
  end

  private
  
    def user_params
      params.require(:user).permit(:name, :bio, :avatar)
    end

end