class ChangeUidtoBigInt < ActiveRecord::Migration
  def change
    change_column :providers, :uid, :bigint
  end
end
