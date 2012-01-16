class ItemsController < ApplicationController

  def busqueda
    @items = Item.search(params[:term], nil, {:type => "page", :fields => "category,name,picture"}).select{|item| ["Tv show", "Musician/band", "Movie", "Book", "Interest", "Sport"].index(item.category)}
    render :json => @items
  end

  def fql_query
    # client.fql_query("select page_id, uid from page_fan where uid in (528755713,100000389125405) and page_id in(select page_id from page_fan where uid = 702141098)")
  end

end
