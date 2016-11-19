class CreateUsersCustomers < ActiveRecord::Migration
  def change
    create_table :users_customers, id: false do |t|
      t.integer :user_id
      t.integer :customer_id
    end
  end
end
