class AddPinyinToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :pinyin, :string
    add_index :customers, :pinyin
  end
end
