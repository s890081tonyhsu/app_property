class AddServiceUnitInLends < ActiveRecord::Migration
  def change
  	add_column :lends, :LendUnit, :string
  end
end
