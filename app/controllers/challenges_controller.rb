class ChallengesController < ApplicationController

  def index
    @top_winners = User.top_winners
    @challenges_in_progress = Challenge.all.where(status: "in_progress").order(challenge_end: :desc)
    @challenges_voting = Challenge.all.where(status: "voting").order(updated_at: :desc)
    @challenges_closed = Challenge.all.where(status: "closed").order(updated_at: :desc).limit(5)
  end

  def in_progress_end
    @challenge = Challenge.find(params[:id])
    if @challenge.evidences.size <= 1
      @challenge.status = 'closed'
      @challenge.save

      respond_to do |format|
        format.js{render 'votes/voting_end'}
      end
    else
      @challenge.status = 'voting'
      @challenge.save
      respond_to do |format|
        format.js
      end
    end

  end

  def update
    @challenge = Challenge.find(params[:id])
    if params[:challenge]
      @challenge.explaination = current_user.name.titleize + " declined for the following reason: " + params[:challenge][:explaination]
      @challenge.save
      redirect_to user_path(current_user)
    end
    if params["commit"] == "Accept"
      @challenge.status = "in_progress"
      @challenge.challenge_end = Time.now + @challenge.challenge_duration.seconds
      @challenge.save
      redirect_to user_path(current_user)
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
    @challenge = Challenge.find(params[:id])
    if @challenge.not_enough_evidence? || @challenge.voting_ended
      @challenge.status = "closed"
    elsif @challenge.inprogress_w_time_expired
      @challenge.status = "voting"
    end
    @challenge.save
  end



  def create
    @challenge = Challenge.new(challenge_params)
    @challenge.title = @challenge.title.titleize
    if current_user.email.downcase == params[:challenge][:challenged_email].downcase
      flash.now[:notice] = "Although challenging yourself is a worthy endeavour, we do not allow it here. Please enter another email."
      render 'new'
    else
    @challenged = User.find_by(email: params[:challenge][:challenged_email])
    @challenge.challenge_duration = (params["challenge"]["challenge_duration"].to_i * params["challenge"]["time_unit_challenge"].to_i)
    @challenge.voting_duration = (params["challenge"]["voting_duration"].to_i * params["challenge"]["time_unit_vote"].to_i)
  
      if @challenge.save
        UserChallenge.create(user_id: current_user.id, challenge_id: @challenge.id, admin: true)
        UserChallenge.create(user_id: @challenged.id, challenge_id: @challenge.id)
      end

      # if #params are set up
      #   
      render 'show'
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :description)
  end


end
