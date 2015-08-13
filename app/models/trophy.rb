class Trophy < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge



  def self.photo_urls
    ['http://images.clipartpanda.com/star-trophy-clipart-cup_trophy.png',
      'http://bestclipartblog.com/clipart-pics/ribbon-clip-art-1.png',
      'http://www.truckclipart.com/free_truck_clipart/stock_photo_of_a_1st_place_gold_cup_0515-1104-2101-4457_SMU.jpg',
      'http://cliparts.co/cliparts/dc4/oo9/dc4oo99qi.gif',
      'http://www.paramus.k12.nj.us/ppsd/History%20of%20Paramus/___zumuhead.html_files/trophy.gif'
    ]
  end

  
end
