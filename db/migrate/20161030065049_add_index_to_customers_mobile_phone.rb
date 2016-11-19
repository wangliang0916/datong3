class AddIndexToCustomersMobilePhone < ActiveRecord::Migration
  def change
    add_index :customers, :mobile_phone, unique: true
  end
end
