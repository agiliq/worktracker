class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authentication

  def authentication
    if session.has_key?'warden.user.user.key'
        if request.fullpath == '/login'
            redirect_to '/'
        end
    else
        if request.fullpath != '/login' and request.fullpath != '/users/auth/google_apps/callback'
            redirect_to '/login'
        end

    end
  end
end
