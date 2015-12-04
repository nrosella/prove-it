class ChallengesController < ApplicationController

  def index
    Challenge.update_status
    @top_winners = User.top_winners
    @challenges_in_progress = Challenge.get_by_status("in_progress")
    @challenges_voting = Challenge.current_voting
    @challenges_closed = Challenge.get_by_status("closed").order_by_.limit(5)
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
      explaination = params[:challenge][:explaination]
      @challenge.set_full_explaination(current_user, explaination)
      redirect_to user_path(current_user)
    end
    if params["commit"] == "Accept"
      @challenge.status = "in_progress"
      @challenge.set_end
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
    challenged_email = params[:challenge][:challenged_email].downcase
    if current_user.email.downcase == challenged_email
      flash.now[:notice] = "Although challenging yourself is a worthy endeavour, we do not allow it here. Please enter another email."
      render 'new'
    elsif User.find_by(email: challenged_email) == nil
      flash.now[:notice] = "Sorry, that email is not associated with a valid account. Please enter a valid user's email."
      render 'new'
    else
      @challenged = User.find_by(email: challenged_email)
      @challenge.get_durations(params)
      if @challenge.save
        UserChallenge.create_all(current_user, @challenge, @challenged)
      end
      render 'show'
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:title, :description)
  end


end
