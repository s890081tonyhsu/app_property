class Item < ActiveRecord::Base
  # 欄位非空
  validates_presence_of :ItemName, :ItemNum, :ItemHeavy, :ItemStatus, :ItemDescription, :ItemDeadline, :message => "該欄位不能為空白"
  # 名字驗證
  validates_length_of :ItemName, :in => 1..32, :message => "名字限制在1~32字之內"
  validates_uniqueness_of :ItemName, :message => "該物品已經登錄到清單中"
  # 物品數量驗證
  validates_numericality_of :ItemNum, :only_integer => true, :message => "只允許數字"
  validates_numericality_of :ItemNum, :greater_than => 0, :message => "必須至少一個物品"
  # 物品價值驗證
  validates_numericality_of :ItemHeavy, :only_integer => true, :message => "只允許數字"
  validates_numericality_of :ItemHeavy, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10, :message => "價值介於1~10之間"
  # 物品狀態確認
  validates_inclusion_of :ItemStatus, :in => [0, 1, 2], :message => "請在既有選項中做出選擇"
  # 物品說明確認
  # 物品可借用天數確認
  validates_numericality_of :ItemDeadline, :only_integer => true, :message => "只允許數字"
  validates_numericality_of :ItemDeadline, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 31, :message => "請給予一個月內的天數"
end
