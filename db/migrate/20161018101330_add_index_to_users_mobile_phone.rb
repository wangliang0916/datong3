class AddIndexToUsersMobilePhone < ActiveRecord::Migration
  def change
    add_index :users, :mobile_phone, unique: true
  end
end
