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
    @itemId = @lendData.ItemId
	@itemTime = Item.find(@itemId).ItemDeadline
	@lendData.DeadTime = (@lendData.PassTime.to_date + @itemTime).iso8601
	@lendData.ItemLendStatus = 2
    if @lendData.save
      render 'show_lend'
	  flash[:notice] = "儲存成功"
    else
	  render 'new_lend'
      flash[:error] = "儲存失敗"
    end	  
  end
  def modify_lend
    @lendId = params[:id]
    @lendData = Lend.find(@lendId)
  end
  def update_lend
    @lendId = params[:id]
    @lendData = Lend.find(@lendId)
    @itemId = @lendData.ItemId
	@itemTime = Item.find(@itemId).ItemDeadline
	@lendData.DeadTime = (@lendData.PassTime.to_date + @itemTime).iso8601
	@lendData.ItemLendStatus = 2
    if @lendData.save
      render 'show_lend'
	  flash[:notice] = "儲存成功"
    else
	  render 'new_lend'
      flash[:error] = "儲存失敗"
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
  
  def verify_params
    
  end
  def lend_params
    params.require(:lend).permit(:LendName, :LendEmail, :ItemId, :ItemLendStatus, :PassTime)
  end
end
