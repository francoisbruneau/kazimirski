# http://blog.weareevermore.com/how-to-add-http-basic-authentication-to-your-rails-application/

module HttpAuthConcern
  extend ActiveSupport::Concern

  included do
    before_action :http_authenticate
  end

  def http_authenticate
    return true unless Rails.env == 'production'

    authenticate_or_request_with_http_basic do |username, password|
      username == 'kazimirski' && password == ENV['HTTP_AUTH_PASSWORD']
    end
  end
end
