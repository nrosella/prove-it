class UsersController < ApplicationController

	def show
		current_user
		@challenges = current_user.challenges
	end

end