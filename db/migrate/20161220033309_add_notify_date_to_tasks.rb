class AddNotifyDateToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :notify_date, :string
  end
end
