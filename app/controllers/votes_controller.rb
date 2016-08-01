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
    @openchallenge.open_winners.each do |user|
        Trophy.create(user_id: user.id, challenge_id: @openchallenge.id, photo_url: Trophy.photo_urls.sample)
    end
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
        
    respond_to do |format|
      format.js
    end


  end

  def vote_boost
    @challenge = Challenge.find(params[:vote][:challenge_id])
    @user = User.find(params[:vote][:user_id])
    @boost = params[:vote][:social_boost]
    fb_data = Facebook.new(session[:fb_token], root_url)
    fb_data.post_to_wall(@challenge, @user, params[:vote][:fb_message])
    respond_to do |format|
      format.js {render :action =>'create' }
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:user_id, :recipient_id, :challenge_id)
  end

end
