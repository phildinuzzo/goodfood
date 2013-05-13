class Favorite < ActiveRecord::Base
  attr_accessible :data, :user_id
  belongs_to :user
end
