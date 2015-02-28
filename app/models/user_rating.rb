class UserRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe

  validates :user, presence: true
  validates :recipe, presence: true
end
