require 'date'
require 'digest/sha2'
class LendController < ApplicationController
  def view_lend
    @lendData = Lend.all
	@itemData = Item
	@lendStart = lendStart
	@lendStart.each do |startData|
	  if startData.ItemLendStatus == 1
        startData.ItemLendStatus = 4
        startData.save
	  end
	end
	@lendExpire = lendExpire
	@lendExpire.each do |expireData|
	  if expireData.ItemLendStatus == 4
        expireData.ItemLendStatus = 3
        expireData.save
	  end
	end
  end
  def show_lend
    @lendId = params[:id]
	@lendData = Lend.find(@lendId)
	@itemData = Item
  end

  def new_lend
    @lendError = 0 
    @lendData = Lend.new
    if params.has_key?(:id)
      @lendData.ItemId = params[:id]
	end
  end
  def create_lend
    @itemData = Item
    @lendData = Lend.new(lend_params)
    begin
      @itemId = @lendData.ItemId
      @itemTime = Item.find(@itemId).ItemDeadline
      @lendData.DeadTime = (@lendData.PassTime.to_date + @itemTime).iso8601
	  unless lendBind('', @itemId, @lendData.PassTime, @lendData.DeadTime).blank?
        flash.now[:error] = "該物品在當期間已有人預約"
	  else
        @lendData.ItemLendStatus = 2
        @lendData.save
        render 'show_lend'
  	    flash.now[:notice] = "儲存成功"
      end
	rescue
      if @lendData.save == false
        @lendError = 1
  	    render 'new_lend'
        flash.now[:error] = "儲存失敗"
      end
	end	  
  end
  def modify_lend
    begin
      @lendData = Lend.find(params[:id])
      token = certification(session[:verify], @lendData)
      case token
        when 0
          flash.now[:notice] = "資料載入成功"
		  @lendError = 0
		  if @lendData.ItemLendStatus % 2 != 0
   	        flash.now[:warning] = "請注意，非審核或是回絕之申請無法進行修改"
		  end
        when 1
      	redirect_to lend_verify_path
          flash[:error] = "你憑證和資料不符合，請重新申請"
        when 2
          redirect_to lend_verify_path
          flash[:error] = "你目前沒有憑證，請重新申請"
        when 3
          redirect_to lend_verify_path
          flash[:error] = "出現未知錯誤，請重新嘗試"
      end
	rescue
	  redirect_to lend_verify_path
	  flash[:error] = "出現未知錯誤，請重新嘗試"
	end
  end
  def update_lend
    begin
   	  @itemData = Item 
   	  @lendId = params[:id]
   	  @lendData = Lend.find(params[:id])
   	  token = certification(session[:verify], @lendData)
   	  case token
   	    when 0
   	      @itemId = @lendData.ItemId
   	      @itemTime = Item.find(@itemId).ItemDeadline
   	      @lendData.DeadTime = (@lendData.PassTime.to_date + @itemTime).iso8601
   	      if @lendData.ItemLendStatus % 2 == 0
   	        @lendData.save
   	        render 'show_lend'
   	        flash.now[:notice] = "儲存成功"
		  elsif !lendBind(@lendId, @itemId, @lendData.PassTime, @lendData.DeadTime).blank?
            render 'modify_lend'
		    flash.now[:error] = "該物品在當期間已有人預約"
		  else
            render 'show_lend'
   	        flash.now[:error] = "抱歉，非審核或是回絕之申請無法進行修改"
		  end
   	    when 1
   	  	redirect_to lend_verify_path
   	      flash[:error] = "你憑證和資料不符合，請重新申請"
   	    when 2
   	      redirect_to lend_verify_path
   	      flash[:error] = "你目前沒有憑證，請重新申請"
   	    when 3
   	      redirect_to lend_verify_path
   	      flash[:error] = "出現未知錯誤，請重新嘗試"
   	  end
	rescue
	  if @lendData.save == false
	    @lendError = 1
        render 'modify_lend'
        flash.now[:error] = "儲存失敗"
      end
    end
  end

  def delete_lend
    begin
      @lendData = Lend.find(params[:id])
      token = certification(session[:verify], @lendData)
	  case token
	    when 0
          redirect_to lend_verify_path(:name => @lendData[:LendName], :email => @lendData[:LendEmail]) 
	      if @lendData.destroy
            flash[:notice] = "刪除成功"
	  	else
            flash[:error] = "刪除失敗"
	  	end
        when 1
	  	redirect_to lend_verify_path
          flash[:error] = "你憑證和資料不符合，請重新申請"
	    when 2
          redirect_to lend_verify_path
	      flash[:error] = "你目前沒有憑證，請重新申請"
        when 3
          redirect_to lend_verify_path
	      flash[:error] = "出現未知錯誤，請重新嘗試"
	  end
	rescue
    end
  end
  
  def verify
    @itemData = Item
    if params.has_key?(:destroy)
	  session.delete(:verify)
	  params[:name] = ''
	  params[:email] = ''
	  @msg = {:data => "已清除當前憑證", :note => "alert alert-success"}
	elsif !session[:verify].blank? && session[:verify][:expires] > Time.now
	  @name = session[:verify][:name]
	  @email = session[:verify][:email]
      @msg = {:data => "目前憑證存在，如果看不到借閱資料請重新輸入表單取得", :note => "alert alert-warning"}
	elsif params.has_key?(:name) && params.has_key?(:email)
	  @name = params[:name]
	  @email = params[:email]
	  session[:verify] = {:name => @name, :email => @email, :value => Digest::SHA2.hexdigest(@name + @email), :expires => Time.now + 3600}
	  @msg = {:data => "已建立一小時暫時憑證，編輯與刪除需透過此憑證", :note => "alert alert-success"}
	else
      session.delete(:verify)
	  @name = ''
	  @email = ''
      @msg = {:data => "請輸入資料以便取得修改資料之憑證", :note => "alert alert-warning"}
	end
	@lendData = Lend.where("LendName = ? AND LendEmail = ?", @name, @email)
  end
 
  def audit
    @error = Array.new
	@itemData = Item
	@success = 0
    if params.has_key?(:audit)
      @data = params[:audit]
      @data.keys.each do |id|
        @editLend = Lend.find(id)
        if Item.where(:id => @editLend.ItemId).blank?
		  nil
        else			
          @editItem = Item.find(@editLend.ItemId)
		end
		case @data[id]
        when 'pass'
          if Item.where(:id => @editLend.ItemId).blank?
            @error.push(@editLend.LendName + "的借用物品已被刪除")
			next
          end
          if @editItem.ItemStatus == 1
            @editLend.ItemLendStatus = 1
            @editItem.ItemStatus = 2
			@editItem.save
          else
            @error.push(@editItem.ItemName + "目前無法借用，請重新審核" + @editLend.LendName + "的借用表單")
          end
        when 'reject'
		  @editLend.ItemLendStatus = 0
		  if Item.where(:id => @editLend.ItemId).blank? == false
		    if @editItem.ItemStatus == 2
              @editItem.ItemStatus = 1
              @editItem.save
            else
              @error.push(@editItem.ItemName + "借用釋放失敗，請到物品管理頁面處理該物品")
            end
		  end
        when 'default'
          nil
        end
		@editLend.save
		@success = 1
      end
    end
    @lendData = Lend.where("ItemLendStatus <= ?",2).order(:ItemLendStatus)
  end

  private

  def lend_params
    params.require(:lend).permit(:LendName, :LendEmail, :LendUnit, :ItemId, :ItemLendStatus, :PassTime)
  end
  def certification(storage, data)
    key = storage[:value]
    token = 3
    begin
      if key == Digest::SHA2.hexdigest(data[:LendName] + data[:LendEmail])
        token = 0
      else
        token = 1
	  end
	rescue
	  token = 2
	end
	token
  end
  def lendStart
    Lend.where('PassTime <= ?', Date.today.iso8601)
  end
  def lendExpire
    Lend.where('DeadTime <= ?', Date.yesterday.iso8601)
  end
  def lendBind(id, item, start, stop)
    @lendScope = Lend.where(ItemId: item, PassTime: (start..stop),  DeadTime: (start..stop)).where.not(id: id)
	@lendScope
  end
end
