class IngredientsController < ApplicationController
  
  include AuthenticationHelper
  
  def index
    @ingredients = Ingredient.order(:name)
  
    @ingredient = Ingredient.new
  end  
  
  def create
    #render plain: params[:recipe].inspect
    
    @ingredient = Ingredient.new(ingredient_params)
 
    if @ingredient.save
      redirect_to action: "index"
    else
      @ingredients = Ingredient.order(:name)
      render 'index'
    end
  end
  
  def show
    @ingredients = Ingredient.order(:name)
    @ingredient = Ingredient.find(params[:id])
    render 'index'
  end
  
  def update
#    render plain: params[:recipe].inspect
    
    @ingredient = Ingredient.find(params[:id])

    if @ingredient.update(ingredient_params)
      redirect_to ingredients_path
    else
      @ingredients = Ingredient.order(:name)
      render 'index'
    end
  end
  
  def destroy
    @deleted_ingredient = Ingredient.find(params[:id])
    if @deleted_ingredient.destroy
      #redirect_to ingredients_path
      message = @deleted_ingredient.name + " deleted successfully"
      redirect_to ingredients_path, :notice => message
    else
      message = @deleted_ingredient.name + " couldn't be deleted: #{@deleted_ingredient.errors[:base].first.to_s}"
      redirect_to ingredients_path, :alert => message
      #@ingredients = Ingredient.order(:name)
      #@ingredient = Ingredient.new
      #render 'index'
    end
   
  end
  
private

  def ingredient_params
    return params.require(:ingredient).permit(:name, :measurement_type_id)
  end
  
end
