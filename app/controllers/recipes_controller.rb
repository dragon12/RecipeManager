class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end
  
  def show
    @recipe = Recipe.find(params[:id])
  end
  
  def new
    
  end
  
  def create
    #render plain: params[:recipe].inspect
    
    @recipe = Recipe.new(recipe_params)
 
    @recipe.save
    redirect_to @recipe
  
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
