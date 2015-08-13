class OpenchallengesController < ApplicationController

  def new
   @challenge = Challenge.new
  end

  def index
    @open_challenges = Challenge.where(:open =>  true)
  end

  def create
    @openchallenge = Challenge.create(openchallenge_params)
    @openchallenge.challenge_duration = params[:challenge][:challenge_duration].to_i * params[:challenge][:time_unit_challenge].to_i
    @openchallenge.challenge_end = Time.now + @openchallenge.challenge_duration.seconds
    @openchallenge.voting_duration = @openchallenge.challenge_duration
    @openchallenge.status = 'voting'
    @openchallenge.creator = current_user.name
    @openchallenge.open = true
    @openchallenge.save
    
    redirect_to openchallenge_path(@openchallenge)
  end

  def show
    @challenge = Challenge.find(params[:id])
    @openchallenge = Challenge.find(params[:id]) 
    if @openchallenge.expired?
      @openchallenge.status = 'closed'
      @openchallenge.open_winners.each do |user|
        Trophy.create(user_id: user.id, challenge_id: @openchallenge.id, photo_url: Trophy.photo_urls.sample)
      end
      @openchallenge.save
    end
  end

  def sort_new
    @openchallenge = Challenge.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def sort_votes
    @openchallenge = Challenge.find(params[:id])

    respond_to do |format|
      format.js
    end
  end


  private

  def openchallenge_params
    params.require(:challenge).permit(:title, :description)
  end


end

