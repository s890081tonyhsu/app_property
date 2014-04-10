class UniqueLendNameByItemIdInLendList < ActiveRecord::Migration
  def change
    add_index :Lends, [:ItemId, :LendName], :unique => true
  end
end
