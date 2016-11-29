class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :customer_id
      t.string :description
      t.string :file

      t.timestamps
    end
  end
end
