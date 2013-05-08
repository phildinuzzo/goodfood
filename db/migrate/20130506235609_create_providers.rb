class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.integer :uid
      t.string :provider
      t.string :token

      t.timestamps
    end
  end
end
