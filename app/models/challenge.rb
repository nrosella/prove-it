class Challenge < ActiveRecord::Base
  attr_accessor :challenged_email

  has_many :notifications
  has_many :user_challenges
  has_many :users, through: :user_challenges
  has_many :votes
  has_many :evidences

  validates :title, presence: true

  def winner
    total_votes.max_by{|k,v| v}[0]
  end

  def loser
    total_votes.min_by{|k,v| v}[0]
  end

  def total_votes
    {}.tap do |results|
      self.users.each do |user|
        results[user] = self.votes.where(recipient_id: user.id).size
      end
    end 
  end

  def competitor1
    self.users.first
  end

  def competitor2
    self.users.second
  end

  def votes1
    self.votes.where(recipient_id: self.competitor1.id).size
  end

  def votes2
    self.votes.where(recipient_id: self.competitor2.id).size
  end

  def evidence_submitted?(user)
    self.evidences.where(user_id: user.id).exists?
  end




end
