class ItemController < ApplicationController
  def view_item
    @itemAll = Item.all
  end
end
