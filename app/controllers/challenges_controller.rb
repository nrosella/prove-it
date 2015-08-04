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
    binding.pry
    @challenge = Challenge.new(challenge_params)
    @challenged = User.find_by(email: params[:challenge][:challenged_email])

    if @challenge.save
      UserChallenge.create(user_id: current_user, challenge_id: @challenge.id, admin: true)
      UserChallenge.create(user_id: @challenged, challenge_id: @challenge.id)
    end

    render 'show'

  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :description, :challenge_duration, :voting_duration)

  end


end
