class HomeController < ApplicationController
  
  def index
    if current_user
      @user = current_user
    end
  end

end
