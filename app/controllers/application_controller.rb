class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def ilt_session
    @auth_redirect_path = request.original_url + '/../'
    if session[:user].blank?
      redirect_to @auth_redirect_path
	  flash[:warning] = '此功能只允許管理員使用'
	end
  end
end
