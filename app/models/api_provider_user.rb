class ApiProviderUser < ActiveRecord::Base
  attr_accessible :api_provider_name, :id_from_provider, :login, :name, :picture
end
