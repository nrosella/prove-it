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

  after_create :send_admin_mail
  
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
    self.challenges.where(status: "closed").select do |challenge|
      challenge.winner == self
    end.count
  end

  def total_losses
    self.challenges.where(status: "closed").count - self.total_wins
  end

  def challenge_pending
    self.challenges.where(status: "pending")
  end

  def challenge_in_progress
    self.challenges.where(status: "in_progress")
  end

  def challenge_voting
    self.challenges.where(status: "voting")
  end

  def challenge_closed
    self.challenges.where(status: "closed")
  end

  def challenge_declined
    self.challenges.where(status: "declined")
  end


end
