class ChallengeViewObject
  attr_accessor :challenge, :user, :current_user

  def initialize(challenge, user, current_user)
    @challenge = challenge
    @user = user
    @current_user = current_user
  end

  def user_name_has
   if user == current_user
     'You have'
   else
     user.name.capitalize + ' has'
   end
  end

  def posessive_name
    if user == current_user
      'your'
    else
     user.name.capitalize + "'s"
    end
  end

  def user_name
    if user == current_user
      "You"
    else
      user.name.capitalize
    end
  end

  def evidence_text
    if self.challenge.voting_or_closed? && self.user.has_submitted_evidence_for(self.challenge)
      "#{posessive_name.capitalize} evidence:"
    elsif self.user.has_submitted_evidence_for(self.challenge) && !self.show_current_user_evidence?
      "#{user_name_has} submitted evidence."     
    elsif self.user.has_submitted_evidence_for(self.challenge)
      "#{posessive_name.capitalize} evidence:"
    elsif self.challenge.in_progress?
       "Awaiting #{posessive_name} evidence.."
    else
      "{user_name} didn't submit evidence in time!"
    end
  end

  def evidence_image
    if challenge.voting_or_closed?
      self.user.evidence_for(challenge)
    elsif show_current_user_evidence?
      self.user.evidence_for(challenge)
    else
      nil
    end
  end

  def show_current_user_evidence?
    self.challenge.in_progress && self.user == self.current_user && self.user.has_submitted_evidence_for(self.challenge)
  end

end
