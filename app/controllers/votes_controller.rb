class VotesController < ApplicationController
  def create
    @challenge = Challenge.find(params[:vote][:challenge_id])
    Vote.create (vote_params)
    if @challenge.votes.size > 10
      @challenge.status = 'closed'
      @challenge.save
    end
    redirect_to challenge_path(@challenge)

  end

  private

  def vote_params
    params.require(:vote).permit(:user_id, :recipient_id, :challenge_id)
  end

end
