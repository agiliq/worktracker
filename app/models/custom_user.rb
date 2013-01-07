class CustomUser < ActiveRecord::Base
  attr_accessible :assembla_id, :github_id, :login, :name, :picture
end
