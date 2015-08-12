class Challenge < ActiveRecord::Base
  attr_accessor :challenged_email, :time_unit_vote, :time_unit_challenge

  has_many :notifications
  has_many :user_challenges
  has_many :users, through: :user_challenges
  has_many :votes
  has_many :evidences

  validates :title, presence: true

# CLASS METHODS -----------

  def self.pending
    self.all.where(status: "pending").order(updated_at: :desc)
  end

  def self.in_progress
    self.all.where(status: "in_progress").order(challenge_end: :desc)
  end

  def self.voting
    self.all.where(status: "voting").order(updated_at: :desc)
  end

  def self.closed
    self.all.where(status: "closed").order(updated_at: :desc)
  end

# INSTANCE METHODS -----------

  def short_description
    if self.description.length > 36
      self.description[0..36] + "..."
    else
      self.description
    end
  end

  def winner
    if self.evidences.length == 1
      self.evidences[0].user
    else 
      total_votes.key(total_votes.values.max) || User.new(name: "nobody")
    end
  end

  def loser
    # note this needs to be tested once loser method implemented somewhere
    loser_by_no_submit = nil
    if self.evidences.length == 1
      binding.pry
      self.users.each do |user|
        if !user.has_submitted_evidence_for(self)
          loser_by_no_submit = user
        end
      end
    end
    loser_by_no_submit || total_votes.key(total_votes.values.min)
  end

  def tie?
    self.winner.name == "nobody"
  end

  def total_votes
    self.votes.group(:recipient_id).count.transform_keys{|key| User.find(key)}
  end

  def print_votes
    total_votes.collect do |k,v|
    "#{k.capitalize_name}: #{ActionController::Base.helpers.pluralize(v, 'vote')}"
    end.join(", ")
  end

  def in_progress
    self.status == "in_progress"
  end

  def declined
    self.status == "declined"
  end

  def closed
    self.status == "closed"
  end

  def in_progress?
    self.status == "in_progress"
  end

  def voting_or_closed?
    ['pending', 'declined', 'in_progress'].exclude?(self.status)
  end

  def pending_or_declined?
    self.status == 'pending' || self.status == 'declined'
  end

  def votes_for(user)
    self.votes.where(recipient_id: user.id).size
  end

  def print_competitors
    self.users.collect{|user| user.name.capitalize}.join(" vs ")
  end


  def rank_of(user)
    if self.total_votes.keys.sort.index(user).present?
      self.total_votes.keys.sort.reverse.index(user) + 1
    else
      self.users.size
    end
  end


  def inprogress_w_time_expired
    self.status == "in_progress" && Time.now > (self.challenge_end)
  end

  def voting_ended
    self.status == "voting" && Time.now > (self.challenge_end + self.voting_duration.seconds)
  end

  def rank_votes(user)
    votez = self.votes.group(:recipient_id).count
    newvotez = votez.each_with_object({}){|(key, value), hash|(hash[value] ||= [] ) << key}
    newvotez2 = newvotez.sort.reverse
    a = newvotez2.collect do |array|
          array[1].size
        end
    index = newvotez2.index(newvotez2.detect do |array|
       newvotez2[newvotez2.index(array)][1].include?(user.id)
    end)
    if index == nil
      self.users.size
    elsif index == 0
      index + 1
    else
      a[0,index].inject(:+) + 1
    end
  end

  def expired?
    Time.now > (self.challenge_end)
  end




end
