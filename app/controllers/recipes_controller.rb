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
    
#    @recipe = Recipe.new(params[:recipe])
#    if params[:add_ingredient_quantity]
#      # add empty ingredient associated with @recipe
#      @recipe.ingredient_quantities.build
#    elsif params[:remove_ingredient_quantity]
#      # nested model that have _destroy attribute = 1 automatically deleted by rails
#    else
#      # save goes like usual
#      if @recipe.save
#        flash[:notice] = "Successfully created recipe."
#        redirect_to @recipe and return
#      end
#    end
#    render :action => 'new'
  end
  
  private
    def recipe_params
      params.require(:recipe).permit(:name, :description)
    end
    
  
end
