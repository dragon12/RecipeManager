class Image < ActiveRecord::Base
  belongs_to :recipe
  
  validates :description, presence: true
  
  validates :url, presence: true, 
            :format => URI::regexp(%w(http https))
                      
end
