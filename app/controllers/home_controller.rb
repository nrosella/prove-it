class HomeController < ApplicationController
  
  def index
    if current_user
      binding.pry
      @user = current_user
    end
  end

end
