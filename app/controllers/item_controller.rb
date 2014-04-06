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
      render action: 'show_item', status: :created, location: @itemNew
    else
      render action: 'new_item' 
    end
  end
  def show_item
    @itemId = params[:id]
    @itemData = Item.find(@itemId)
  end

  def item_params
    params.require(:item).permit(:ItemName, :ItemNum, :ItemHeavy, :ItemStatus, :ItemDescription, :ItemDeadline)
  end
end
