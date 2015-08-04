class Challenge < ActiveRecord::Base

  belongs_to :challenger, :class_name => "User"
  belongs_to :challenged, :class_name => "User"

  has_many :notifications

  validates :title, presence: true
  validates :challenged_id, presence: true
 
  
  
end
