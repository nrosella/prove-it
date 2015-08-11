class VotesController < ApplicationController
  def create
    @challenge = Challenge.find(params[:vote][:challenge_id])
    Vote.create(vote_params)
    respond_to do |format|
      format.js
    end
  end

  def index
    @challenge = Challenge.find(params[:id])
    @challenge.status = 'closed'
    @challenge.save
    respond_to do |format|
      format.js
    end
  end

  def new
    @challenge = Challenge.find(params[:id])
    @challenge.status = 'voting'
    @challenge.save

    respond_to do |format|
      format.js
    end
  end

  def open_vote
    @vote = Vote.create(vote_params)
    @challenge = Challenge.find(params[:vote][:challenge_id])
    @recipient = @vote.recipient
    @user_ids = @challenge.users.collect{|user| user.id}
    @user_votes = @user_ids.collect do |user|
      @challenge.votes.where(recipient_id: user).size
    end
    
    respond_to do |format|
      format.js
    end


  end

  private

  def vote_params
    params.require(:vote).permit(:user_id, :recipient_id, :challenge_id)
  end

end
