class Provider < ActiveRecord::Base
  attr_accessible :provider, :token, :uid
  belongs_to :user

end
