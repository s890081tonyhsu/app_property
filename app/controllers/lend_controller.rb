require 'date'
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
  	  flash[:notice] = "儲存成功"
	rescue
      if @lendData.save == false
  	    render 'new_lend'
        flash[:error] = "儲存失敗"
      end
	end	  
  end
  def modify_lend
    @lendId = params[:id]
    @lendData = Lend.find(@lendId)
  end
  def update_lend
	@itemData = Item 
    @lendId = params[:id]
	begin
      @lendData = Lend.find(@lendId)
      @itemId = @lendData.ItemId
	  @itemTime = Item.find(@itemId).ItemDeadline
	  @lendData.DeadTime = (@lendData.PassTime.to_date + @itemTime).iso8601
	  @lendData.ItemLendStatus = 2
      @lendData.save
      render 'show_lend'
	  flash[:notice] = "儲存成功"
	rescue
	  if @lendData.save == false
	    render 'new_lend'
        flash[:error] = "儲存失敗"
      end
    end
  end

  def delete_lend
    @lendData = Lend.find(params[:id])
	@lendData.destroy
	redirect_to :action => 'view_lend'
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
end
