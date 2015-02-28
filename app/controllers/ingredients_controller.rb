class IngredientsController < ApplicationController
  before_action :admin_user, only: [:edit, :update, :destroy]

  @is_admin = false
  
  def index
    setup_vars
    @ingredients = Ingredient.order(:name)
    @ingredient = Ingredient.new
  end  
  
  def create
    #render plain: params[:recipe].inspect
    setup_vars
    @ingredient = Ingredient.new(ingredient_params)
 
    if @ingredient.save
      redirect_to action: "index"
    else
      @ingredients = Ingredient.order(:name)
      render 'index'
    end
  end
  
  def show
    setup_vars
    @ingredients = Ingredient.order(:name)
    @ingredient = Ingredient.find(params[:id])
    render 'index'
  end
  
  def update
    setup_vars
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
    setup_vars
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
  def setup_vars
    @is_admin = current_user && current_user.is_admin?
  end

  def ingredient_params
    return params.require(:ingredient).permit(:name, :measurement_type_id, 
                                                  :cost_basis, :cost, :cost_note,
                                                  :kcal_basis, :kcal, :kcal_note)
  end
  
  
  # Confirms an admin user.
  def admin_user
    unless logged_in? && current_user.is_admin?
      flash[:danger] = "Must be admin to modify ingredients"
      redirect_to(ingredients_url) 
    end
  end
end
