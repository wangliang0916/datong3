class AddTypeToNotifies < ActiveRecord::Migration
  def change
    add_column :notifies, :type, :string
  end
end
