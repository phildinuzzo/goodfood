class AddDataToFavorite < ActiveRecord::Migration
  def change
    # we're storing the hashed info object from the api call
    add_column :favorites, :data, :text

    # address and saved are not needed anymore.
    remove_column :favorites, :address
    remove_column :favorites, :saved
  end
end
