class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :admin_challenges, class_name: "Challenge", :foreign_key => "challenger_id"
  has_many :guest_challenges, class_name: "Challenge", :foreign_key => "challenged_id"

  has_many :notifications

  def all_challenges
    Challenge.where(challenger_id: self.id) | Challenge.where(challenged_id: self.id)
  end

  def all_challenges_better
    self.admin_challenges | self.guest_challenges
  end



  
  
end
