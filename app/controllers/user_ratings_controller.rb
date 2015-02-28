class UserRatingsController < ApplicationController
  before_action :setup_recipe
  before_action :logged_in_user

  def create
    @user_rating = UserRating.new(user_ratings_params)
    
    unless @user_rating.save
      flash[:danger] = "Failed to save rating: #{user_rating.errors.full_messages}"
    end
    redirect_to @recipe
  end

  def update
    @user_rating = UserRating.find_or_create_by(id: params[:id])
    @user_rating.update(user_ratings_params)
    unless @user_rating.save
      flash[:danger] = "Failed to save rating: #{user_rating.errors.full_messages}"
    end
    redirect_to @recipe
  end
  
private
  def setup_recipe
    logger.debug("USER_RATINGS: #{user_ratings_params.inspect}")
    recipe_id = user_ratings_params[:recipe_id]
    logger.info("USER_RATINGS: recipe_id = #{recipe_id}")
    
    if (recipe_id.blank?)
      logger.debug("USER_RATINGS: blank!")
      flash[:danger] = "Must supply recipe id in the query!"
      redirect_to recipes_url
    else
      @recipe = Recipe.find(recipe_id)
    end
  end
  
  def user_ratings_params
    return params.require(:user_rating)
            .permit(:recipe_id, :user_id, :rating)
  end
  
    # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to @recipe
    end
  end
  
end
