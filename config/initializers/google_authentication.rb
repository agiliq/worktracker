# Use this hook to configure GoogleAuthentication, values in the comments are defaults
GoogleAuthentication.setup do |config|

  # ==> Domain configuration
  # Configure here the domain used for the authentication
  config.domain = ENV['WORKTRACKER_AUTH_DOMAIN']

  # ==> Model configuration
  # Configure here the model name, it should be the model you've generated
  # using the provided generator. Don't change after first generation
  # unless you know what you're doing
  # config.model_name = :user

end
