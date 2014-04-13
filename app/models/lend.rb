class Lend < ActiveRecord::Base
  # 欄位非空
  validates_presence_of :LendName, :LendEmail, :ItemId, :ItemLendStatus, :PassTime, :DeadTime, :message => "該欄位不能為空白"
  # 姓名驗證
  validates_length_of :LendName, :in => 1..32, :message => "名字限制在1~32字之內"
  validates_uniqueness_of :ItemId, :scope => :LendName, :message => "你已經借閱過該物品"
  # 電子郵件確認
  # 借用物品確認
  # 預定借用日期確認

end
