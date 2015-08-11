class ChallengesController < ApplicationController

  def in_progress_end
    @challenge = Challenge.find(params[:id])
    @challenge.status = 'voting'
    @challenge.save
  

    respond_to do |format|
      format.js
    end
  end

  def update
    @challenge = Challenge.find(params[:id])
    if params[:challenge]
      @challenge.explaination = current_user.name.titleize + " declined for the following reason: " + params[:challenge][:explaination]
      @challenge.save
      redirect_to user_path
    end
    if params["commit"] == "Accept"
      @challenge.status = "in_progress"
      @challenge.challenge_end = Time.now + @challenge.challenge_duration.seconds
      @challenge.save
      redirect_to user_path
    elsif params["commit"] == "Decline"
      @challenge.status = "declined"
      @challenge.save
      render 'explaination'
    end
     
  end


    #this is logic for changing statuses 1. pending -> "in progress"


  def new
    @challenge = Challenge.new
  end

  def show
    @challenge = Challenge.find(params["id"])
    if (@challenge.inprogress_w_time_expired && @challenge.evidences.length == 1)
      @challenge.status = "closed"
      @challenge.save
      elsif @challenge.inprogress_w_time_expired
        @challenge.status = "voting"
        @challenge.save
    end
    if @challenge.voting_ended
      @challenge.status = "closed"
      @challenge.save
    end
  
  end



  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.title = @challenge.title.titleize
    if current_user.email.downcase == params[:challenge][:challenged_email].downcase
      flash.now[:notice] = "Sorry, self challenges not allowed."
      binding.pry
      render 'new'
    else
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
  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :description)
  end


end
