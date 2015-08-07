class VotesController < ApplicationController
  def create
    @challenge = Challenge.find(params[:vote][:challenge_id])
    Vote.create(vote_params)
    if @challenge.votes.size > 10
      @challenge.status = 'closed'
      @challenge.save
    end
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

  private

  def vote_params
    params.require(:vote).permit(:user_id, :recipient_id, :challenge_id)
  end

end
