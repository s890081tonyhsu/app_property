class BindLastLended < ActiveRecord::Migration
  def change
		add_column :items, :LastLendId, :integer
  end
end
