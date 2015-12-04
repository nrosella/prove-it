class UserChallenge < ActiveRecord::Base
  belongs_to :user 
  belongs_to :challenge

  def self.create_all(current_user, challenge, challenged)
    UserChallenge.create(user_id: current_user.id, challenge_id: challenge.id, admin: true)
    UserChallenge.create(user_id: challenged.id, challenge_id: challenge.id)
  end

end