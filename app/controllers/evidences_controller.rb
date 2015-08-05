class EvidencesController < ApplicationController

  def create
    @challenge = Challenge.find(params[:evidence][:challenge_id])
    e = Evidence.new(evidence_params)
    e.save
    if @challenge.evidences.length == 2
      @challenge.status = 'voting'
      @challenge.save
    end
    
    redirect_to challenge_path(@challenge)
  end



  private

  def evidence_params
  params.require(:evidence).permit(:photo, :comment, :challenge_id, :user_id)
end

end