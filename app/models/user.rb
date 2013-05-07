class User < ActiveRecord::Base
  attr_accessible :email, :name, :location
  has_many :providers
  validates :email, :uniqueness => true
  def self.create_with_omniauth(auth)
    create! do |user|
      p = Provider.new
      p.token = auth['credentials']['token']
      p.uid = auth["uid"]
      p.provider = auth['provider']

      user.email = auth['info']["email"]
      user.name = auth["info"]["name"]
      user.location = auth['info']['location']

      user.providers << p
    end
  end
  def self.find_with_omniauth(auth)
   p = Provider.where(:provider => auth['provider'], :uid => auth['uid'])
   p.first.user
  end
end
