class User < ActiveRecord::Base
  attr_accessible :email, :name, :location
  has_many :providers
  validates :email, :uniqueness => true

  # creates the User object with omniauth hash
  def self.create_with_omniauth(auth)
    create! do |user|
      p = Provider.new
      p.token = auth['credentials']['token']
      p.uid = auth["uid"]
      p.provider = auth['provider']

      user.email = auth['info']["email"]
      user.name = auth["info"]["name"]
      user.location = auth['info']['location']

      ## creates the relationship between Provider and User
      user.providers << p
    end
  end

  ## find provider using oauth hash and return a that object
  def self.find_with_omniauth(auth)
   p = Provider.where(:provider => auth['provider'], :uid => auth['uid'])
   p.first
  end
end
