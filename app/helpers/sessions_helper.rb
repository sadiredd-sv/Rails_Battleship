module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    # The purpose of this line is to create current_user, accessible
    # in both controllers and views, which will allow constructions such as
    self.current_user = user
    #{session[:remember_token] =  user.remember_token }
  end

  def signed_in?
    !current_user.nil?
  end

  # self.current_user = ...
  # is automatically converted to
  # current_user=(...)
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
