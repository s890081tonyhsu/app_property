class Lend < ActiveRecord::Base
  # 欄位非空
  validates_presence_of :LendName, :LendEmail, :LendUnit, :ItemId, :ItemLendStatus, :PassTime, :DeadTime, :message => "該欄位不能為空白"
  # 姓名驗證
  validates_length_of :LendName, :in => 1..32, :message => "名字限制在1~32字之內"
  validates_uniqueness_of :ItemId, :scope => :LendName, :message => "你已經借閱過該物品"
  # 單位確認
  validates_length_of :LendUnit, :in => 1..32, :message => "名字限制在1~32字之內"
  # 電子郵件確認
  validates_format_of :LendEmail, :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :message => "非規格之電子郵件地址"
  # 借用物品確認
  # 預定借用日期確認

end
