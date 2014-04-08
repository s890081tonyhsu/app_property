class CreateLends < ActiveRecord::Migration
  def change
    create_table :lends do |t|
      t.string :LendName
	  t.string :LendEmail
	  t.integer :ItemId
	  t.integer :ItemLendStatus
	  t.date :PassTime
	  t.date :DeadTime
      t.timestamps
    end
  end
end
