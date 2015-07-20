class ChildrenController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    if current_user.faculty? 
      current_user.redirect_if_menu_id_invalid
    end 
    @user = current_user
    @children = @user.children
  end

  def search 
    @children = Child.search(params[:search_term],params[:search]).order(sort_column + " " + sort_direction)
  end

  # def show
  # end

  def edit
    @user = current_user
    @child = @user.children.find(params[:id])
  end

  def update
    @user = current_user
    @child = @user.children.find(params[:id])
    @children = @user.children 
    if @child.update_attributes(child_params)
    flash[:notice] = "Child information was updated."
    redirect_to user_children_path
    else
      flash[:error] = "There was an error editing the child. Please try again."
      render :edit
    end 
  end

  def new
    @user = current_user
    @child = Child.new
  end

  def create
    @user = current_user
    @children = @user.children
    @child = @user.children.create(child_params)
    @child.save!
    if @child.save
     flash[:notice] = "You have added your child to the system."
     redirect_to user_children_path
    else
     flash[:error] = "Error adding your child. Please check you have entered all the applicable fields"
    end
  end

  def destroy
   @user = current_user
   @child = @user.children.find(params[:id])
   @children = @user.children
   if @child.destroy
     flash[:notice] = "\"#{@child.first_name}\" was removed successfully."
     redirect_to user_children_path(@user.id, @children)
   else
     flash[:error] = "Couldn't remove child right now."
   end
 end

  # def destroy 

  #   @user = current_user
  #    if @child.destroy
  #      flash[:notice] = "\"#{@child.name}\" was removed successfully."
  #      redirect_to user_children_path(@user)
  #    else
  #      flash[:error] = "There was an error."
  #    end
  # end 

  private 
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def child_params
    params.require(:child).permit(:first_name, :last_name, :grade, :campus, :menu_id, :email)
  end
end
