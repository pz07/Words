# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

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
  
  protected
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end
    
    def object_to_boolean(value)
      return [true, "true", 1, "1", "T", "t"].include?(value.class == String ? value.downcase : value)
    end
  
  private
    def get_layout
      params[:popup] == 'true' ? "popup" : "application"
    end
  
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

end
