class RecipesController < ApplicationController
   http_basic_authenticate_with name: "gers", 
                                password: "myrecipes", 
                                except: [:index, :show]
  
  #before_filter :authenticate, except: [:index, :show]

  #def authenticate
  #  authenticate_or_request_with_http_basic do |username, password|
  #    @authenticated = username == "foo" && password == "bar"
  #  end
  #end
#
#  def authenticated?
#    @authenticated
#  end
#  helper_method :authenticated?
  
  def index
    @search_ingredient = Ingredient.new
    
    if !params[:search_by_name].blank?
      @recipes = Recipe.search_by_name(params[:search_by_name]).order("created_at DESC")
    elsif !params[:search_by_ingredient].blank?
      @recipes = Recipe.search_by_ingredient(params[:search_by_ingredient]).order("created_at DESC")
    elsif !params[:search_by_ingredient_id].blank?
      @recipes = Recipe.search_by_ingredient_id(params[:search_by_ingredient_id]).order("created_at DESC")
      @search_ingredient = Ingredient.find(params[:search_by_ingredient_id])
    else
      @recipes = Recipe.all
    end
    render'index'
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
  end
  
  def update
#    render plain: params[:recipe].inspect
    
    @recipe = Recipe.find(params[:id])
# @recipe.update(recipe_params)
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render 'edit'
    end
  end
  
  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
   
    redirect_to recipes_path
  end

  def new
    #we create an empty recipe here so that there is always a 'recipe' variable available to the template
    @recipe = Recipe.new
  end
  
  def create
    #render plain: params[:recipe].inspect
    
    @recipe = Recipe.new(recipe_params)
 
    if @recipe.save
      redirect_to @recipe
    else
      render 'new'
    end
    
  end
  
  private
    def recipe_params
      ret_params = params.require(:recipe)
        .permit(:name, :description, :comments, :_destroy,
                links_attributes: [:id, :url, :_destroy],
                instructions_attributes: [
                  :id,
                  :step_number, 
                  :details,
                  :_destroy],
                ingredient_quantities_attributes: [
                      :id, 
                      :quantity, 
                      :preparation,
                      :ingredient_name,
                      :ingredient_id,
                      {:ingredient => [:name, :id]},
                      {:ingredient_attributes => [:name, :id]},
                      :_destroy]
                )
    
      return ret_params
      
    end
    
  
end
