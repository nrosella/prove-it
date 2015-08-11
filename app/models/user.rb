class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :notifications
  has_many :votes
  has_many :user_challenges
  has_many :challenges, through: :user_challenges
  has_many :evidences

  # after_create :send_admin_mail
  
  def send_admin_mail
    UserMailer.send_welcome_email(self).deliver_now!
  end

  def send_challenge_invitation_email(challenge)
    UserMailer.send_invitation_email(self, challenge).deliver_now!
  end

  def competing?(challenge)
    challenge.users.include?(self)
  end

  def voted?(challenge)
    challenge.votes.where(user_id: self.id).exists?
  end

  def has_submitted_evidence_for(challenge)
    self.challenges.find_by(id: challenge.id).evidences.find_by(user_id: self.id).present?
  end

  def total_wins
    self.challenges_won.count
  end

  def total_losses
    self.challenges.where(status: "closed").count - self.total_wins
  end


  def challenge_pending
    self.challenges.where(status: "pending").order(updated_at: :desc)
  end

  def challenge_in_progress
    self.challenges.where(status: "in_progress").order(updated_at: :desc)
  end

  def challenge_voting
    self.challenges.where(status: "voting").order(updated_at: :desc)
  end

  def challenge_closed
    self.challenges.where(status: "closed").order(updated_at: :desc)
  end


  # def challenges_won
  #   user.challenges.closed
  # end
  
  def challenges_won
    self.challenges.where(status: "closed").order(updated_at: :desc).select{|c| c.winner == self}
  end

  def challenges_lost
    self.challenges.where(status: "closed").order(updated_at: :desc).select{|c| c.winner != self}
  end

  def challenge_declined
    self.challenges.where(status: "declined").order(updated_at: :desc)
  end

  def evidence_for(challenge)
    if challenge.evidences.find_by(user_id: self.id)
      challenge.evidences.find_by(user_id: self.id).photo.url
    end
  end

  def capitalize_name
    self.name.capitalize
  end


end
