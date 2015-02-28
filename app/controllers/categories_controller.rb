class CategoriesController < ApplicationController
  before_action :admin_user, only: [:edit, :update, :destroy]

  @is_admin = false
  
  def index
    setup_vars
    @categories = Category.order(:name)
    @category = Category.new
  end

  def create
    setup_vars
    @category = Category.new(category_params)
 
    if @category.save
      redirect_to action: "index"
    else
      @categorys = Category.order(:name)
      render 'index'
    end
  end
  
  def show
    setup_vars
    @categories = Category.order(:name)
    @category = Category.find(params[:id])
    render 'index'
  end
  
  def update
    setup_vars
#    render plain: params[:recipe].inspect
    
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to categories_path
    else
      @categories = Category.order(:name)
      render 'index'
    end
  end
  
  def destroy
    setup_vars
    @deleted_category = Category.find(params[:id])
    if @deleted_category.destroy
      #redirect_to categorys_path
      message = @deleted_category.name + " deleted successfully"
      redirect_to categories_path, :notice => message
    else
      message = @deleted_category.name + " couldn't be deleted: #{@deleted_category.errors[:base].first.to_s}"
      redirect_to categories_path, :alert => message
      #@categorys = category.order(:name)
      #@category = category.new
      #render 'index'
    end
   
  end
  
private
  def setup_vars
    @is_admin = current_user && current_user.is_admin?
  end
  
  def category_params
    return params.require(:category).permit(:name)
  end
  
   
  # Confirms an admin user.
  def admin_user
    unless logged_in? && current_user.is_admin?
      flash[:danger] = "Must be admin to modify categories"
      redirect_to(categories_url) 
    end
  end
end
