class VotesController < ApplicationController
  def create
    @challenge = Challenge.find(params[:vote][:challenge_id])
    Vote.create(vote_params)
    respond_to do |format|
      format.js
    end
  end

  def voting_end
    @challenge = Challenge.find(params[:id])
    @challenge.status = 'closed'
    @challenge.save
    respond_to do |format|
      format.js
    end
  end

  def open_voting_end
    @openchallenge = Challenge.find(params[:id])
    @openchallenge.status = 'closed'
    @openchallenge.save
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
    @openchallenge = Challenge.find(params[:vote][:challenge_id])
    @recipient = @vote.recipient
    @user_ids = @openchallenge.users.collect{|user| user.id}
    @user_votes = @user_ids.collect do |user|
      @openchallenge.votes.where(recipient_id: user).size
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
