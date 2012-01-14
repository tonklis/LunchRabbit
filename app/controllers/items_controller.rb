class ItemsController < ApplicationController

  def search_page
    @items = Item.search(params[:query], nil, {:type => :page}])
  end

  def fql_query
    # client.fql_query("select page_id, uid from page_fan where uid in (528755713,100000389125405) and page_id in(select page_id from page_fan where uid = 702141098)")
  end

end
