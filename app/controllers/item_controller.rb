class ItemController < ApplicationController

  def view_item
    @itemData = Item.all
    @itemData.each do |eachitem|
      @lendscope = lendBind(@itemId) || nil
      @itemStatus = eachitem.ItemStatus
      if @itemStatus != 1
        if !@lendscope
          eachitem.LastLendId = @lendscope.id
        else
          eachitem.LastLendId = 0
        end
        eachitem.ItemStatus = (eachitem.LastLendId != 0)? 2:1
        eachitem.save
      end
    end
  end
  def show_item
    @itemId = params[:id]
    @itemData = Item.find(@itemId)
    @lendscope = lendBind(@itemId) || nil
    if @itemStatus != 1
      if !@lendscope
        @itemData.LastLendId = @lendscope.id
      else
        @itemData.LastLendId = 0
      end
      @itemData.ItemStatus = (eachitem.LastLendId != 0)? 2:1
      @itemData.save
    end
  end
  def manage_item
    @itemData = Item.all
  end

  def new_item
    @itemError = 0
    @itemData = Item.new
  end
  def create_item
    @itemData = Item.new(item_params)
    if @itemData.save 
      flash.now[:notice] = "儲存成功"
      render 'show_item'
    else
      @itemError = 1
      flash.now[:error] = "儲存失敗"
      render 'new_item'
    end
  end

  def modify_item
    @itemId = params[:id]
    @itemData = Item.find(@itemId)
  end
  def update_item
    @itemId = params[:id]
    @itemData = Item.find(@itemId)
    if @itemData.update_attributes(item_params)
      flash.now[:success] = "儲存成功"
      render 'show_item'
    else
      @itemError = 1
      flash.now[:error] = "儲存失敗"
      render 'modify_item'
    end
  end

  def delete_item
    @itemData = Item.find(params[:id])
    @itemData.destroy
    redirect_to :action => 'view_item'
  end

  private

  def item_params
    params.require(:item).permit(:ItemName, :ItemNum, :ItemHeavy, :ItemStatus, :ItemDescription, :ItemDeadline)
  end
  def lendBind(item)
    @today = Date.today.iso8601
    @lendScope = Lend.where("ItemId = ? AND PassTime < ? AND DeadTime > ?", item, @today, @today)
    @lendScope
  end
end
