class Lend < ActiveRecord::Base
  # 欄位非空
  validates_presence_of :LendName, :LendEmail, :ItemId, :ItemLendStatus, :PassTime, :DeadTime
  # 相同物品名下不允許同名借閱者
  validates_uniqueness_of :ItemId, :scope => :LendName
end
