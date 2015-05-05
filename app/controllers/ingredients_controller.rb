class IngredientsController < ApplicationController
  before_action :admin_user, only: [:edit, :update, :destroy]

  @is_admin = false
  
  def index
    setup_vars
    @ingredient_links = IngredientLink.order_by_name
    @simple_ingredient_bases = IngredientBase.simples_ordered_by_name
    @complex_ingredient_bases = IngredientBase.complex_ordered_by_name
    @ingredient = Ingredient.new
  end  
  
  def create
    #render plain: params[:recipe].inspect
    logger.info("params: #{params.inspect}")
    setup_vars

    name = params[:name]
    
    @ingredient = Ingredient.new(ingredient_params)
    
    if @ingredient.save
      redirect_to action: "index"
    else
      @ingredient_links = IngredientLink.order_by_name
      render 'index'
    end
  end
  
  def show
    setup_vars
    @ingredient_links = IngredientLink.order_by_name
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
      @ingredient_links = IngredientLink.order_by_name
      render 'index'
    end
  end
  
  def destroy
    setup_vars
    @deleted_ingredient = Ingredient.find(params[:id])
    name = @deleted_ingredient.name
    if @deleted_ingredient.destroy
      #redirect_to ingredients_path
      message = name + " deleted successfully"
      redirect_to ingredients_path, :notice => message
    else
      message = name + " couldn't be deleted; it still has recipes"
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
