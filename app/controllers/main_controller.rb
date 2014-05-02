class MainController < ApplicationController
  require 'ilt_template'
  def index
  end
  def about
  end
  def intrroduction
  end
  def auth
    @app_property = IltOAuthClient.new
    @app_property.key = ENV['ILT_KEY']
    @app_property.secret = ENV['ILT_SECRET']
    @app_property.host_url = 'http://ilt.nchusg.org/oauth'
	@app_property.redirect_url = request.original_url
    @app_property.scope = 'user.login.basic+user.login.student+user.info.basic+user.info.student+user.info.personal'
    @app_property.token = params['token'] || ''
	@app_property.status = params['status'] || 0
	@data_content = @app_property.run
	if @app_property.token && @app_property.status == 0
      redirect_to @data_content
    else
      session[:data] = params['data']
      redirect_to ilt_signin_path
	end
  end
  def session_create
    session[:back_url] = session[:back_url].blank?? params['back_url'] : session[:back_url]
    @back_url = session[:back_url]
    if !cookies[:user_name].blank?
      session.delete(:back_url)
      nil
    elsif session[:data].blank?
      redirect_to ilt_auth_path
	else
	  session[:user] = session[:data]
	  session.delete(:data)
	  session.delete(:back_url)
	end
  end
  def session_destroy
    session[:back_url] = params['back_url']
    session.delete(:user)
	@back_url = session[:back_url]
	session.delete(:back_url)
  end
end
