class Challenge < ActiveRecord::Base
  attr_accessor :challenged_email

  has_many :notifications
  has_many :user_challenges
  has_many :challenges, through: :user_challenges

  validates :title, presence: true
    
end
