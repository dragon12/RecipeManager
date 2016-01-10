class UserRatingsController < ApplicationController
  before_action :setup_recipe
  before_action :logged_in_user

  def create
    logger.info("USER_RATING: creating from params: #{params.inspect}")
    #ur = @recipe.user_ratings.build(user_ratings_params)
    
    ur = UserRating.new(user_ratings_params)
    ur.recipe_id = @recipe.id
    @recipe.user_ratings << ur
    unless ur.save
     flash[:danger] = "Failed to save rating: #{ur.errors.full_messages}"
    end
    @recipe.reload
    redirect_to @recipe
  end

  def update
    logger.info("USER_RATING: params in: #{params.inspect}")
    @user_rating = UserRating.find_or_create_by(id: params[:id])
    logger.info("USER_RATING: Found user rating: #{@user_rating.inspect}")
    @user_rating.update(user_ratings_params)
    unless @user_rating.save
      flash[:danger] = "Failed to save rating: #{@user_rating.errors.full_messages}"
    end
    redirect_to @recipe
  end
  
  def destroy
    logger.info("USER_RATING: destroy; params in: #{params.inspect}")
    @user_rating = UserRating.find_or_create_by(id: params[:id])
    logger.info("USER_RATING: Found user rating: #{@user_rating.inspect}")
    if @user_rating.destroy
      flash[:info] = "Successfully deleted rating"
    else
      flash[:danger] = "Failed to delete rating: #{@user_rating.errors.full_messages}"
    end
    redirect_to @recipe
  end
  
private
  def setup_recipe
    logger.debug("USER_RATINGS IN SETUP: #{params.inspect}")
    recipe_id = params[:recipe_id]
    logger.info("USER_RATINGS: recipe_id = #{recipe_id}")
    
    if (recipe_id.blank?)
      logger.debug("USER_RATINGS: blank!")
      flash[:danger] = "Must supply recipe id in the query!"
      redirect_to recipes_url
    else
      @recipe = Recipe.friendly.find(recipe_id)
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
