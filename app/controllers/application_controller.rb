# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  layout :get_layout
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '05fa39063dc52bb3e63f8c94828686e8'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  def url_for(options = {})
    url = super options
    if params[:popup] == "true"
      if url.include? "?"
        url + "&popup=true"
      else
        url + "?popup=true"
      end
    else
      url
    end
  end
  
  private
    def get_layout
      params[:popup] == 'true' ? "popup" : "application"
    end

end
