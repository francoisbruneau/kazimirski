class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: "kazimirski", password: ENV['HTTP_AUTH_PASSWORD']

  def permission_denied
    render :file => "public/401.html", :status => :unauthorized
  end
end
