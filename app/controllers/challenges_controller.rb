class ChallengesController < ApplicationController

  def index
  end

  def update
    # binding.pry
     # if params["commit"] == "Accept"

    #this is logic for changing statuses 1. pending -> "in progress"
  end

  def new
    @challenge = Challenge.new
  end

  def show
    @challenge = Challenge.find(params["id"])

  end



  def create
   
    @challenge = Challenge.new(challenge_params)
    @challenged = User.find_by(email: params[:challenge][:challenged_email])

    # current_user.challenges << @challenge

    # @challenged.challenges << @challenge

    # current_user.save
    # @challenged.save


    if @challenge.save

      UserChallenge.create(user_id: current_user.id, challenge_id: @challenge.id, admin: true)
      UserChallenge.create(user_id: @challenged.id, challenge_id: @challenge.id)
    binding.pry
    end

    render 'show'

  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :description, :challenge_duration, :voting_duration)

  end


end
