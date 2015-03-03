helpers do
  
  def session_set_current_user(user)
    session[:current_user_id] = user.id
  end

  def session_logout_current_user
    session[:current_user_id] = nil
  end

  def session_current_user
    return nil if session[:current_user_id].blank?
    User.find(session[:current_user_id])
  end

  def current_user
    @current_user ||= User.find_by_id(session[:current_user_id]) if session[:current_user_id]
  end
  
end
