class Challenge < ActiveRecord::Base
  
  has_attached_file :challenger_evidence, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :challenger_evidence, :content_type => /\Aimage\/.*\Z/

  has_attached_file :challenged_evidence, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :challenged_evidence, :content_type => /\Aimage\/.*\Z/

  belongs_to :challenger, :class_name => "User"
  belongs_to :challenged, :class_name => "User"
 
  
  
end
