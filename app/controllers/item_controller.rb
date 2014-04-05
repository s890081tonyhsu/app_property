class ItemController < ApplicationController
  def view_item
    @itemAll = Item.all
  end
  def new_item
    @itemNew = Item.new
  end
  def create_item
    @itemCreate = Item.new(params[:item])
	@itemCreate.save
  end
  def show_item
    @itemId = params[:id]
    @itemShow = Item.find(@itemId)
  end
end
