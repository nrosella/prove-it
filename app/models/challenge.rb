class Challenge < ActiveRecord::Base
  attr_accessor :challenged_email, :time_unit_vote, :time_unit_challenge

  has_many :notifications
  has_many :user_challenges
  has_many :users, through: :user_challenges
  has_many :votes
  has_many :evidences

  validates :title, presence: true



  

  def winner
    total_votes.key(total_votes.values.max) || User.new(name: "nobody")
  end

  def loser
    total_votes.key(total_votes.values.min)
  end

  def total_votes
    self.votes.group(:recipient_id).count.transform_keys{|key| User.find(key)}
  end

  def print_votes
    total_votes.collect do |k,v|
    "#{k.name}: #{v} votes"
    end.join(", ")
  end

  # def set_event_duration(event_duration, number, unit)
  #   self.send(event_duration)= number * unit
  # end

end
