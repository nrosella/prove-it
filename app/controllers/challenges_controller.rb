class ChallengesController < ApplicationController

  def index
  end

  def update
    @challenge = Challenge.find(params[:id])
    if params["commit"] == "Accept"
      @challenge.status = "in_progress"
      @challenge.challenge_end = Time.now + @challenge.challenge_duration.seconds
      @challenge.save
    elsif params["commit"] == "Decline"
      @challenge.status = "declined"
      @challenge.save
    end
    redirect_to user_path 
  end


    #this is logic for changing statuses 1. pending -> "in progress"


  def new
    @challenge = Challenge.new
  end

  def show
    @challenge = Challenge.find(params["id"])
    if (@challenge.status == "in_progress" && Time.now > (@challenge.challenge_end) )
      @challenge.status = "voting"
      @challenge.save
    end
  
  end



  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.title = @challenge.title.titleize

    @challenged = User.find_by(email: params[:challenge][:challenged_email])
    @challenge.challenge_duration = (params["challenge"]["challenge_duration"].to_i * params["challenge"]["time_unit_challenge"].to_i)
    @challenge.voting_duration = (params["challenge"]["voting_duration"].to_i * params["challenge"]["time_unit_vote"].to_i)
  
    if @challenge.save
      UserChallenge.create(user_id: current_user.id, challenge_id: @challenge.id, admin: true)
      UserChallenge.create(user_id: @challenged.id, challenge_id: @challenge.id)
      # @challenged.send_challenge_invitation_email(@challenge)
    end

    render 'show'

  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :description)
  end


end
