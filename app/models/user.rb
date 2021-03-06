class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :notifications
  has_many :votes
  has_many :user_challenges
  has_many :challenges, through: :user_challenges
  has_many :evidences
  has_many :trophies

  after_create :send_admin_mail

  def self.top_winners
    self.all.sort_by {|user| user.total_wins }.reverse[0..9]
  end
  
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

  def self.from_omniauth(auth)
    
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.avatar = open(auth.info.image)
         # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
     super.tap do |user|
       if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
         user.email = data["email"] if user.email.blank?
       end
     end
   end

  def has_pending?
    self.challenge_pending.size > 0
  end

  def has_voting?
    self.challenge_voting.size > 0
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
  
  def challenges_won
    self.challenges.where(status: "closed").order(updated_at: :desc).select{|c| c.winner == self}
  end

  def challenges_lost
    self.challenges.where(status: "closed").order(updated_at: :desc).select{|c| c.winner != self}
  end

  def challenge_declined
    self.challenges.where(status: "declined").order(updated_at: :desc)
  end

  def challenge_accepted
    self.challenges.where(status: "in_progress").order(updated_at: :desc)
  end

  def evidence_for(challenge)
    if challenge.evidences.find_by(user_id: self.id)
      challenge.evidences.find_by(user_id: self.id).photo.url
    end
  end

  def competitors
    competition = Hash.new(0)
    self.challenges.where.not(status: :pending).each do |challenge|
      challenge.users.each do |user|
        unless user == self
          competition[user] += 1
        end
      end
    end
    competition.sort_by {|_user, occurence| occurence }.reverse
  end

  def top_3_competitors
    self.competitors[0..2]
  end

  def capitalize_name
    self.name.capitalize
  end

  def challenge_declined_count
    self.challenge_declined.count
  end

  # def challenge_accepted_count
  #   self.challenge_accepted.count
  # end

  def challenge_accepted_count
    self.challenges.where.not(status: "pending").order(updated_at: :desc).count
  end

  def participation_chart
    if challenge_accepted_count > 0
    @participation_data = 
        [
          {
              value: self.challenge_declined_count,
              color:"#F7464A",
              highlight: "#FF5A5E",
              label: "Declined"
          },
          {
              value: self.challenge_accepted_count,
              color: "#18bc9c",
              highlight: "#5AD3D1",
              label: "Accepted"
          }
      ]
    else
      @participation_data = "grgr"
    end
  end

  def any_wins_or_losses
    total_wins > 0 || total_losses > 0
  end

  def doughnut_chart_data
    if any_wins_or_losses
      @chart_data = 
        [
          {
              value: self.total_wins,
              color: "#18bc9c",
              highlight: "#5AD3D1",
              label: "Total wins"
          },
          {
              value: self.total_losses,
              color: "#F7464A",
              highlight: "#FF5A5E",
              label: "Total losses"
          }
      ]
    else
      @chart_data = "rgrg"
    end
  end


  def doughnut_chart_options

    @options = {
      width: '150px',
      height: '150px'
    }
  end

  def open_challenges_won
    Challenge.all.select do |challenge|
      challenge.open? && (challenge.status == 'closed') && challenge.open_winners.include?(self)
    end
  end


end
