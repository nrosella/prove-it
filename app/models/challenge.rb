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


end
