class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :ItemName
	  t.integer :ItemNum
	  t.integer :ItemHeavy
	  t.integer :ItemStatus
	  t.text :ItemDescription
	  t.integer :ItemDeadline
      t.timestamps
    end
  end
end
