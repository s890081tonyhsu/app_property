require 'date'
require 'digest/sha2'
class LendController < ApplicationController
  def view_lend
    @lendData = Lend.all
	@itemData = Item
	@LendExpire = Lend.find(:all, :conditions => ["DeadTime <= ?", Date.yesterday.iso8601])
	@LendExpire.each do |expireData|
	  if expireData.ItemLendStatus == 1
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
      @lendData.ItemLendStatus = 2
      @lendData.save
      render 'show_lend'
  	  flash.now[:notice] = "儲存成功"
	rescue
      if @lendData.save == false
  	    render 'new_lend'
        flash.now[:error] = "儲存失敗"
      end
	end	  
  end
  def modify_lend
    begin
      @lendData = Lend.find(params[:id])
      token = certification(cookies[:verify], @lendData)
      case token
        when 0
          flash.now[:notice] = "資料載入成功"
		  if @lendData.ItemLendStatus % 2 != 0
   	        flash.now[:info] = "請注意，非審核或是回絕之申請無法進行修改"
		  end
        when 1
      	redirect_to lend_verify_path
          flash.now[:error] = "你憑證和資料不符合，請重新申請"
        when 2
          redirect_to lend_verify_path
          flash.now[:error] = "你目前沒有憑證，請重新申請"
        when 3
          redirect_to lend_verify_path
          flash.now[:error] = "出現未知錯誤，請重新嘗試"
      end
	rescue
	  redirect_to lend_verify_path
	  flash.now[:error] = "出現未知錯誤，請重新嘗試"
	end
  end
  def update_lend
    begin
   	  @itemData = Item 
   	  @lendId = params[:id]
   	  @lendData = Lend.find(params[:id])
   	  token = certification(cookies[:verify], @lendData)
   	  case token
   	    when 0
   	      @itemId = @lendData.ItemId
   	      @itemTime = Item.find(@itemId).ItemDeadline
   	      @lendData.DeadTime = (@lendData.PassTime.to_date + @itemTime).iso8601
   	      if @lendData.ItemLendStatus % 2 == 0
   	        @lendData.save
   	        render 'show_lend'
   	        flash.now[:notice] = "儲存成功"
          else
            render 'show_lend'
   	        flash.now[:warning] = "抱歉，非審核或是回絕之申請無法進行修改"
		  end
   	    when 1
   	  	redirect_to lend_verify_path
   	      flash.now[:error] = "你憑證和資料不符合，請重新申請"
   	    when 2
   	      redirect_to lend_verify_path
   	      flash.now[:error] = "你目前沒有憑證，請重新申請"
   	    when 3
   	      redirect_to lend_verify_path
   	      flash.now[:error] = "出現未知錯誤，請重新嘗試"
   	  end
	rescue
	  if @lendData.save == false
	    render 'new_lend'
        flash.now[:error] = "儲存失敗"
      end
    end
  end

  def delete_lend
    begin
      @lendData = Lend.find(params[:id])
      token = certification(cookies[:verify], @lendData)
	  case token
	    when 0
          redirect_to lend_verify_path(:name => @lendData[:LendName], :email => @lendData[:LendEmail]) 
	      if @lendData.destroy
            flash.now[:notice] = "刪除成功"
	  	else
            flash.now[:error] = "刪除失敗"
	  	end
        when 1
	  	redirect_to lend_verify_path
          flash.now[:error] = "你憑證和資料不符合，請重新申請"
	    when 2
          redirect_to lend_verify_path
	      flash.now[:error] = "你目前沒有憑證，請重新申請"
        when 3
          redirect_to lend_verify_path
	      flash.now[:error] = "出現未知錯誤，請重新嘗試"
	  end
	rescue
    end
  end
  
  def verify
    @itemData = Item
    if params.has_key?(:name) && params.has_key?(:email)
		@name = params[:name]
		@email = params[:email]
		@lendData = Lend.where("LendName = ? AND LendEmail = ?", @name, @email)
    else
		@name = ""
		@email = ""
    end
	if cookies[:verify]
      @msg = {:data => "目前憑證存在，如果看不到借閱資料請重新輸入表單取得", :note => "alert alert-warning"}
	elsif @lendData.blank? == false
      cookies[:verify] = {:value => Digest::SHA2.hexdigest(@name + @email), :expires => Time.now + 60}
	  @msg = {:data => "已建立憑證，編輯與刪除需透過此憑證", :note => "alert alert-success"}
	else
      @msg = {:data => "請輸入資料以便取得修改資料之憑證", :note => "alert alert-warning"}
	end
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

  def lend_params
    params.require(:lend).permit(:LendName, :LendEmail, :LendUnit, :ItemId, :ItemLendStatus, :PassTime)
  end
  def certification(key, data)
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
end
