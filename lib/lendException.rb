class LendException < StandardError
  def initialize(error_name, pos)
    @error_msg = "出現錯誤: " + send(error_name)
    flash.now[:error] = @error_msg
    if pos == 'new'
      render 'new_lend'
    elsif pos == 'modify'
      render 'modify_lend'
    else
      redirect_to index
    end
  end
  def lend_notAllowed
    return "此物品無法借用或不存在"
  end
  def lend_OverLimit
    return "超出可借用時間限制"
  end
  def lend_Exists
    return "該物品在當期間已有人預約"
  end
  def save_Failed
    return "儲存失敗"
  end
  def block_edit
    return "抱歉，非審核或是回絕之申請無法進行修改"
  end
end

class VerifyException < StandardError
  def initialize(error_name)
    @error_msg = "出現錯誤: " + send(error_name)
    flash.now[:error] = @error_msg
    redirect_to lend_verify_path
  end
  def not_equal_verify
    return "你憑證和資料不符合，請重新申請"
  end
  def not_verify
    return "你目前沒有憑證，請重新申請"
  end
  def unexpected_error
    return "出現未知錯誤，請重新嘗試"
  end
end