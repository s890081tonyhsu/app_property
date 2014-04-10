class Item < ActiveRecord::Base
  # 欄位非空
  validates_presence_of :ItemName, :ItemNum, :ItemHeavy, :ItemStatus, :ItemDescription, :ItemDeadline
  # 名字介於1~32之間
  validates_length_of :ItemName, :in => 1..32
  # 物品數量至少一個
  validates_numericality_of :ItemNum, :greater_than => 0
  # 確保該物品為唯一
  validates_uniqueness_of :ItemName
end
