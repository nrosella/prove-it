class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  def recipient
    User.find(self.recipient_id)
  end
  
end
