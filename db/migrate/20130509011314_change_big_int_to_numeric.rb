class ChangeBigIntToNumeric < ActiveRecord::Migration
  def change
    change_column :providers, :uid, :numeric
  end
end
