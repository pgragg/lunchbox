module ChildrenHelper

  def button_class
    value = @user.children.count >= 1 ? "" : "btn-lg btn-midpage"
    "btn btn-success btn_bottom #{value}"
  end 

end
