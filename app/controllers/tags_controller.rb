class TagsController < ApplicationController
  before_action :admin_user, only: [:edit, :update, :destroy]

  @is_admin = false
  
  def index
    setup_vars
    @tags = Tag.order(:name)
    @tag = Tag.new
  end

  def create
    setup_vars
    @tag = Tag.new(tag_params)
 
    if @tag.save
      redirect_to action: "index"
    else
      @tags = Tag.order(:name)
      render 'index'
    end
  end
  
  def show
    setup_vars
    @tags = Tag.order(:name)
    @tag = Tag.find(params[:id])
    render 'index'
  end
  
  def update
    setup_vars
#    render plain: params[:recipe].inspect
    
    @tag = Tag.find(params[:id])

    if @tag.update(tag_params)
      redirect_to tags_path
    else
      @tags = Tag.order(:name)
      render 'index'
    end
  end
  
  def destroy
    setup_vars
    @deleted_tag = Tag.find(params[:id])
    if @deleted_tag.destroy
      #redirect_to tags_path
      message = @deleted_tag.name + " deleted successfully"
      redirect_to tags_path, :notice => message
    else
      message = @deleted_tag.name + " couldn't be deleted: #{@deleted_tag.errors[:base].first.to_s}"
      redirect_to tags_path, :alert => message
      #@tags = tag.order(:name)
      #@tag = tag.new
      #render 'index'
    end
   
  end
  
private
  def setup_vars
    @is_admin = current_user && current_user.is_admin?
  end
  
  def tag_params
    return params.require(:tag).permit(:name)
  end
  
   
  # Confirms an admin user.
  def admin_user
    unless logged_in? && current_user.is_admin?
      flash[:danger] = "Must be admin to modify tags"
      redirect_to(tags_url) 
    end
  end
end
