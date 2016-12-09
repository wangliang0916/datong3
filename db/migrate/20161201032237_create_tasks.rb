class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :customer_name
      t.string :customer_mobile_phone
      t.string :content
      t.string :notify_time

      t.timestamps
    end
  end
end
