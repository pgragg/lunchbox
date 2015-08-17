class ChildrenController < ApplicationController
  helper_method :sort_column, :sort_direction

  include ChildSearch 


  def index
    if current_user.faculty? 
      current_user.redirect_if_menu_id_invalid
    end 
    @user = current_user
    @children = @user.children
    params[:amount] ||= 50
    @duplicates = Match.children #Child.all_similar_by(params[:amount].to_i)
  end

  def search 
    @children = Child.search(params[:search_term],params[:search]).order(sort_column + " " + sort_direction)
    @potential_dupes_exist = (Match.all.count > 0)
  end

  def find_duplicates 
    ChildSearch::Matches.compile_matches
    redirect_to :back
  end 

  def edit
    @user = current_user 
    @child = Child.find(params[:id]) 
    @user = @child.parent if current_user.admin? 
    #Allows editing other people's children. 
  end

  def update
    @user = current_user
    @child = Child.find(params[:id]) #@user.children.find(params[:id])
    @user = @child.parent if current_user.admin? 
    @children = @user.children 
    if @child.update_attributes(child_params)
    flash[:notice] = "Child information was updated."
    redirect_to user_children_path unless current_user.admin? 
    redirect_to child_search_path(Child.all) if current_user.admin? 
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
    @user = current_user unless current_user.admin? 
    @children = @user.children
    @child = @user.children.create(child_params)
    # @user = @child.parent if current_user.admin? 
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
   @child = Child.find(params[:id])
   @children = @user.children
   if @child.destroy
     flash[:notice] = "\"#{@child.first_name}\" was removed successfully."
     redirect_to user_children_path(@user.id, @children)
   else
     flash[:error] = "Couldn't remove child right now."
   end
 end

  private 
  def sort_column
    Child.column_names.include?(params[:sort]) ? params[:sort] : "last_name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def child_params
    params.require(:child).permit(:first_name, :last_name, :grade, :campus, :menu_id, :email)
  end
end
