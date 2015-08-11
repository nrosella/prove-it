class UsersController < ApplicationController

	def show
    if current_user
      @challenges = current_user.challenges
      @user = current_user
    else
      @user = User.find(params[:id])
      @challenges = @user.challenges.where.not(status: 'pending')
    end
<<<<<<< HEAD

	 @challenge_data = 
    [
	    {
	        value: 300,
	        color:"#F7464A",
	        highlight: "#FF5A5E",
	        label: "Red"
	    },
	    {
	        value: 500,
	        color: "#46BFBD",
	        highlight: "#5AD3D1",
	        label: "Green"
	    }
  ]
=======
>>>>>>> TuesdayFrontEndMJ
	end

  def edit
    @user = current_user

  end

end