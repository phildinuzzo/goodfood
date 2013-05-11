class AddFavoritedToFavorites < ActiveRecord::Migration
  def change
    add_column :favorites, :saved, :boolean
  end
end
