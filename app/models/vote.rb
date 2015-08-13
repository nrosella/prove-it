class Vote < ActiveRecord::Base
  attr_accessor :social_boost
  belongs_to :user
  belongs_to :challenge

  def recipient
    User.find(self.recipient_id)
  end

  
  
end
