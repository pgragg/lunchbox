module LunchChoicesHelper

  def chosen_or_not(user, lunch)
    return "unchosen" if user.admin?
    user.chose(lunch) ? 'chosen' : 'unchosen'
  end

end
