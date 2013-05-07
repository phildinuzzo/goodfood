class User < ActiveRecord::Base
  attr_accessible :email, :name, :location
  has_many :providers
  validates :email, :uniqueness => true
  def self.create_with_omniauth(auth)
    create! do |user|
      p = Provider.new
      p.token = auth['credentials']['token']
      p.uid = auth["uid"]

      user.email = auth['info']["email"]
      user.name = auth["info"]["name"]
      user.location = auth['info']['location']

      user.providers << p
    end
  end
  def self.find_with_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end
end
