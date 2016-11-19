class AddPinyinToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pinyin, :string
    add_index :users, :pinyin
  end
end
