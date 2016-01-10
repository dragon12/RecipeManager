class Link < ActiveRecord::Base
  belongs_to :recipe
  
  validates :description, presence: true
  
  validates :url, presence: true, 
            :format => URI::regexp(%w(http https))
                      
  auto_strip_attributes :url, :description, :nullify => false, :squish => true
end
