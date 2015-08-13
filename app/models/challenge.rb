class Challenge < ActiveRecord::Base
  attr_accessor :challenged_email, :time_unit_vote, :time_unit_challenge, :fb_post

  has_many :notifications
  has_many :user_challenges
  has_many :users, through: :user_challenges
  has_many :votes
  has_many :evidences
  has_many :trophies

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
    if self.evidences.length == 1 #Only one user submits evidence
      self.evidences[0].user
    else
      if tie? #what if no votes?
        User.new(name: "nobody")
      else
        total_votes.key(total_votes.values.max) || User.new(name: "nobody")
      end
    end
  end

  def tie?
    votes = total_votes.values.sort.reverse
    votes[0] == votes[1]
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


  def count_votes
    self.votes.group(:recipient_id).count
  end


  def total_votes
    count_votes.transform_keys{|key| User.find(key)}
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


  # def rank_of(user)
  #   if self.total_votes.keys.sort.index(user).present?
  #     self.total_votes.keys.sort.reverse.index(user) + 1
  #   else
  #     self.users.size
  #   end
  # end


  def inprogress_w_time_expired
    self.status == "in_progress" && Time.now > (self.challenge_end)
  end

  def voting_ended
    self.status == "voting" && Time.now > (self.challenge_end + self.voting_duration.seconds)
  end

  def rank_of(user)
    if non_adjusted_place(user).nil?
      last_place
    elsif non_adjusted_place(user) == 0
      1
    else
      adjusted_place(user) + 1
    end
  end

  def swap_keys_values(hash)
    hash.each_with_object({}){|(key, value), hash|(hash[value] ||= [] ) << key}
  end

  def compile_votes
    swap_keys_values(count_votes).sort.reverse
  end

  def population_each_place
    compile_votes.collect{|array| array[1].size}
  end

  def non_adjusted_place(user)
    compile_votes.index(place_group(user))
  end

  def place_group(user)
    compile_votes.detect do |array|
       compile_votes[compile_votes.index(array)][1].include?(user.id)
    end
  end

  def last_place
    self.users.size
  end

  def adjusted_place(user)
    population_each_place[0, non_adjusted_place(user)].inject(:+)
  end

  def expired?
    Time.now > (self.challenge_end)
  end

  def open_winners
    if self.votes.present?
      compile_votes[0][1].collect do |user_id|
        User.find(user_id)
      end
    else
      [User.new(name: "nobody")]
    end
  end

  def print_open_winners
    open_winners.collect{|user| user.capitalize_name}.join(" and ") + pluralize_win
  end

  def pluralize_win
    open_winners.size > 1 ? " win!" : " wins!"
  end

end

