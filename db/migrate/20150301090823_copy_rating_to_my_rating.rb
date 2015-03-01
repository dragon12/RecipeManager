class CopyRatingToMyRating < ActiveRecord::Migration
  def change
    me = User.find_by! email: 'gerard0sweeney@gmail.com'
    
    recipes = Recipe.all
    recipes.each do |r|
      ur = UserRating.new()
      ur.recipe = r
      ur.user = me
      ur.rating = r.rating
      ur.save!
    end
  end
end
