class ChallengeViewObject
  attr_accessor :challenge, :user

  def initialize(challenge, user)
    @challenge = challenge
    @user = user
  end

  def user_name
   if user == current_user
     'your'
   else
     user.name.capitalize
   end
  end

  def evidence_text
     if user.has_submitted_evidence_for(challenge)
       "#{user_name} evidence"
     elsif challenge.status == "in_progess"
       "Awaiting your evidence..."
     else
       "#{user_name} didn't submit evidence in time"
     end
  end



end