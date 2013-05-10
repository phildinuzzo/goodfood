class Favorite < ActiveRecord::Base
  attr_accessible :address, :user_id
  belongs_to :user


  def add_favorite

  end



end
