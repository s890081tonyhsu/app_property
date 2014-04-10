class UniqueItemNameInItemList < ActiveRecord::Migration
  def change
    add_index :Items, :ItemName, :unique => true
  end
end
