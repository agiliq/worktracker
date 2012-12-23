class User < ActiveRecord::Base
  attr_accessible :assembla_id, :email, :login, :name, :organization, :phone, :picture, :string
end
