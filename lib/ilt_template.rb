require 'cgi'
require 'open-uri'
require 'active_support/all'
class IltOAuthClient
  attr_accessor :key, :secret, :host_url, :scope, :token, :redirect_url, :status

  public

  def run
    if @token.blank? && @status == 0
      get_token
    else
	  url = get_data(token)
      data_json = open(url).read
      ActiveSupport::JSON.decode(data_json)
    end
  end

  private

  def authorize
    "#{@host_url}/auth_server"
  end
  def request_token
    "#{@host_url}/resource_owner"
  end
  def access_token
    "#{@host_url}/resource_server"
  end
  
  def get_token
    "#{authorize}?client_key=#{@key}&redirect_uri=#{CGI::escape(@redirect_url)}&scope=#{@scope}"
  end
  def get_data(token)
    "#{access_token}?token=#{token}&client_key=#{@key}&client_secret=#{@secret}"
  end
end
