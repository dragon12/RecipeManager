class UserRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :recipe

  validates :user, presence: true
  validates :recipe, presence: true
  validates :rating, presence: true, 
              numericality: { 
                greater_than_or_equal_to: 0,
                less_than_or_equal_to: 10 }

  validates_uniqueness_of :user, scope: :recipe_id
  validates_uniqueness_of :recipe, scope: :user_id
end
