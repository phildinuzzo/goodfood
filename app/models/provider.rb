class Provider < ActiveRecord::Base
  attr_accessible :provider, :token, :uid
  belongs_to :user

  def self.find_with_omniauth(auth)
    p = Provider.where(:provider => auth['provider'], :uid => auth['uid'])
    p.first
  end

  def self.create_with_omniauth(auth)
    create(uid: auth['uid'], provider: auth['provider'], token: auth['credentials']['token'])
  end
end
