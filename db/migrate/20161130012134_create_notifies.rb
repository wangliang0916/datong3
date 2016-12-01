class CreateNotifies < ActiveRecord::Migration
  def change
    create_table :notifies do |t|
      t.integer :customer_id
      t.string :content
      t.string :date
      t.string :time

      t.timestamps
    end
  end
end
