class User < ActiveRecord::Base
  # You can add other devise modules here as arguments, as in devise calls. :omniauthable module is always added
  # and forbidden devise modules are automatically removed (see GoogleAuthentication::ActsAsGoogleUser::FORBIDDEN_MODULES)
  # if you change this line, remember to edit the generated migration
  acts_as_google_user
  # attr_accessible :title, :body
end
