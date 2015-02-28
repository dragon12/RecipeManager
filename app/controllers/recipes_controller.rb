class RecipesController < ApplicationController
  before_action :setup_vars
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]

  @is_admin = false
  
  def index
    @search_ingredient = Ingredient.new
    @search_category = Category.new
    
    if !params[:search_by_name].blank?
      @recipes = Recipe.search_by_name(params[:search_by_name]).order("created_at DESC")
      @filtered_text = "name like '%s'" % params[:search_by_name]
    elsif !params[:search_by_ingredient].blank?
      @recipes = Recipe.search_by_ingredient(params[:search_by_ingredient]).order("created_at DESC")
      @filtered_text = "containing ingredients like '%s'" % params[:search_by_ingredient]
    elsif !params[:search_by_ingredient_id].blank?
      @recipes = Recipe.search_by_ingredient_id(params[:search_by_ingredient_id]).order("created_at DESC")
      @search_ingredient = Ingredient.find(params[:search_by_ingredient_id])
      @filtered_text = "containing '%s'" % @search_ingredient.name
    elsif !params[:search_by_category_id].blank?
      @recipes = Recipe.search_by_category_id(params[:search_by_category_id]).order("created_at DESC")
      @search_category = Category.find(params[:search_by_category_id])
      @filtered_text = "in category '%s'" % @search_category.name
    else
      #@recipes = Recipe.joins(:category).order('categories.name asc, name asc')
      @recipes = Recipe.order(:created_at)
    end
    @recipes = @recipes.paginate(page: params[:page])
    render 'index'
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
    
    ingredient_group = @recipe.ingredient_quantity_groups.build(name: "Default")
    ingredient_group.ingredient_quantities << IngredientQuantity.new
    
    instruction_group = @recipe.instruction_groups.build(name: "Default")
    instruction_group.instructions << Instruction.new
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
        .permit(:name, :description, :comments, :category_id, :total_time, :active_time, 
                  :cooking_time, :rating, :portion_count, :_destroy,
                links_attributes: [:id, :description, :url, :_destroy],
                instruction_groups_attributes: [
                  :id,
                  :name,
                  :_destroy,
                  {:instructions_attributes => [
                    :id,
                    :step_number, 
                    :details,
                    :_destroy]
                  }
                ],
                ingredient_quantity_groups_attributes: [
                  :id,
                  :name,
                  :_destroy,
                  {:ingredient_quantities_attributes => [
                      :id, 
                      :quantity, 
                      :preparation,
                      :ingredient_name,
                      :ingredient_id,
                      {:ingredient => [:name, :id]},
                      {:ingredient_attributes => [:name, :id]},
                      :_destroy]
                    }
                  ]
                )
      if ret_params.has_key?("instruction_groups_attributes")
        instruction_groups = ret_params["instruction_groups_attributes"]
        
        instruction_groups = Recipe.filter_blank_instructions_from_groups(instruction_groups)
        
        ret_params["instruction_groups_attributes"] = instruction_groups;
      end

      if ret_params.has_key?("ingredient_quantity_groups_attributes")
        iq_groups = ret_params["ingredient_quantity_groups_attributes"]
        
        iq_groups = Recipe.filter_blank_ingredient_quantities_from_groups(iq_groups)
        
        ret_params["ingredient_quantity_groups_attributes"] = iq_groups
      end

      logger.info(ret_params)
      return ret_params
      
    end
    
  def setup_vars
    @is_admin = current_user && current_user.is_admin?
  end
     
  # Confirms an admin user.
  def admin_user
    unless @is_admin
      flash[:danger] = "Must be admin to modify recipes"
      redirect_to(recipes_url) 
    end
  end
end
