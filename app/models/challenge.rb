class Challenge < ActiveRecord::Base
  attr_accessor :challenged_email, :time_unit_vote, :time_unit_challenge

  has_many :notifications, :dependent => :destroy
  has_many :user_challenges, :dependent => :destroy
  has_many :users, through: :user_challenges
  has_many :votes, :dependent => :destroy
  has_many :evidences, :dependent => :destroy
  has_many :trophies, :dependent => :destroy

  validates :title, presence: true

  scope :get_by_status, -> (status) { where("status = ?",status) }
  scope :order_by_updated, -> {order(updated_at: :desc)}

  def title=(title)
    if title
      write_attribute(:title, title.titleize)
    else
      write_attribute(:title, nil)
    end
  end

  def set_full_explaination(current_user, explaination)
    self.explaination = current_user.name.titleize + " declined for the following reason: " + explaination
    save
  end

  def set_end
    self.challenge_end = Time.now + challenge_duration.seconds
    save
  end

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
      if tie?
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

  def count_votes
    self.votes.group(:recipient_id).count
  end


  def total_votes
    count_votes.transform_keys{|key| User.find(key)}
  end

  def print_votes
    total_votes.collect do |k,v|
    "#{k.name.split(" ")[0].capitalize}: #{ActionController::Base.helpers.pluralize(v, 'vote')}"
    end.join(", ")
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

  def get_durations(params)
    self.challenge_duration = (params["challenge"]["challenge_duration"].to_i * params["challenge"]["time_unit_challenge"].to_i)
    self.voting_duration = (params["challenge"]["voting_duration"].to_i * params["challenge"]["time_unit_vote"].to_i)
  end

  def compile_votes
    swap_keys_values(count_votes).sort.reverse
  end

  def population_each_place
    compile_votes.collect{|array| array[1].size}
  end

  def adjusted_place(user)
    population_each_place[0, non_adjusted_place(user)].inject(:+)
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

  def not_enough_evidence?
    self.inprogress_w_time_expired && self.evidences.length <= 1
  end

  def challenge_created_by
    self.user_challenges.where(admin: true)[0].user
  end

  def self.challenges_voting
    Challenge.all.where(status: "voting").order(updated_at: :desc)
  end


  def self.current_in_progress
    challenges = Challenge.all.where(status: "in_progress")
    challenges.each do |challenge|
      if challenge.inprogress_w_time_expired
        challenge.status = "closed"
        challenge.save
      end
    end
  end

  def self.update_status
    current_in_progress
    current_voting
  end

  def self.current_voting
    challenges = challenges_voting
    challenges.each do |challenge|
      if challenge.voting_ended
        challenge.status = 'closed'
        challenge.save
      end
    end
  end


end

