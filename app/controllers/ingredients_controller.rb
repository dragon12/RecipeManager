class IngredientsController < ApplicationController
  
  def index
    @ingredients = Ingredient.order(:name)
  
    @ingredient = Ingredient.new
  end  
  
  def create
    #render plain: params[:recipe].inspect
    
    @ingredient = Ingredient.new(params.require(:ingredient).permit(:name))
 
    if @ingredient.save
      redirect_to action: "index"
    else
      @ingredients = Ingredient.order(:name)
      render 'index'
    end
  end  
  
  def destroy
    @ingredient = Ingredient.find(params[:id])
    if @ingredient.destroy
      redirect_to ingredients_path
    else
      @ingredients = Ingredient.order(:name)
      render 'index'
    end
   
  end
end
