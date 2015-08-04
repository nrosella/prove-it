class ChallengesController < ApplicationController

  def index
    

  end

  def new
    @challenge = Challenge.new
  end

  def show
    @challenge = Challenge.find(params["id"])

  end



  def create
    
    @challenge = Challenge.new(challenge_params)

    @challenge.challenged = User.find_by(email: params[:challenge]["challenged_id"])
    @challenge.challenger = current_user
    @challenge.save
    binding.pry
    
    
    current_user.save
  

    # binding.pry

    render 'show'

  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :description, :challenge_duration, :voting_duration)

  end


end
