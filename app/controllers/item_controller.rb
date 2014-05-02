class ItemController < ApplicationController
  before_filter :ilt_session, :except => [:view_item, :show_item]

  def view_item
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
    @itemError = 0
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
  
  def show_item
    @itemId = params[:id]
    @itemData = Item.find(@itemId)
  end

  def manage_item
    @itemData = Item.all
  end

  def item_params
    params.require(:item).permit(:ItemName, :ItemNum, :ItemHeavy, :ItemStatus, :ItemDescription, :ItemDeadline)
  end
end
