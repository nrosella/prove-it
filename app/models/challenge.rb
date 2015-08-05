class Challenge < ActiveRecord::Base
  attr_accessor :challenged_email

  has_many :notifications
  has_many :user_challenges
  has_many :users, through: :user_challenges

  has_many :evidences

  validates :title, presence: true
    
end
