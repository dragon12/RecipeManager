class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  def edit
    @recipe = Recipe.find(params[:id])
  end
  
  def update
    @recipe = Recipe.find(params[:id])
 
    if @recipe.update(recipe_params)
      redirect_to @recipe
    else
      render 'edit'
    end
  end
  
  def destroy
    @recipe = recipe.find(params[:id])
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
        .permit(:name, :description, 
                links_attributes: [:id, :url, :_destroy],
                instructions_attributes: [:id, :details, :_destroy],
                ingredient_quantities_attributes: [:id, :quantity, :_destroy])
    
      return ret_params
      
    end
    
  
end
