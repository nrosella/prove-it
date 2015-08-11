class EvidencesController < ApplicationController

 
  def create
    @challenge = Challenge.find(params[:evidence][:challenge_id])
    e = Evidence.new(evidence_params)
    e.save
    if @challenge.evidences.length == @challenge.users.size
      @challenge.status = 'voting'
      @challenge.challenge_end = Time.now
      @challenge.save
    end

    redirect_to challenge_path(@challenge)
  end

  def open_create
    @openchallenge = Challenge.find(params[:evidence][:challenge_id])
    @openchallenge.users << current_user
    @openchallenge.save
    e = Evidence.new(evidence_params)
    e.save

    redirect_to  openchallenge_path(@openchallenge)
  end

  def open_new
    @open_challenge_id = params[:evidence][:challenge_id]
  end



  private

  def evidence_params
    params.require(:evidence).permit(:photo, :comment, :challenge_id, :user_id)
  end

end