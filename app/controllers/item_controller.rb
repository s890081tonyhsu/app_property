class ItemController < ApplicationController
  def view_item
    @itemData = Item.all
  end
  def new_item
    @itemData = Item.new
  end
  def create_item
    @itemData = Item.new(item_params)
    if @itemData.save
      render 'show_item'
	  flash[:notice] = "儲存成功，以下是你的欄位資訊"
    else
	  render 'new_item'
      flash[:error] = "儲存失敗，請查看欄位是否有誤"
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
      redirect_to :action => 'show_item'
	  flash[:notice] = "儲存成功，以下是你的欄位資訊"
    else
	  render 'edit_item'
      flash[:error] = "儲存失敗，請查看欄位是否有誤"
    end
  end

  def delete_item
    @itemData = Item.find(params[:id])
	@itemData.destroy
	redirect_to :action => 'view_item'
  end
  
  def show_item
    @itemId = params[:id]
    @itemData = Item.find(@itemId)
  end

  def item_params
    params.require(:item).permit(:ItemName, :ItemNum, :ItemHeavy, :ItemStatus, :ItemDescription, :ItemDeadline)
  end
end
