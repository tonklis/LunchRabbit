class ItemsController < ApplicationController

  def busqueda
    @items = Item.search(params[:term], nil, {:type => "page", :fields => "category,name,picture"})
    item_ids = []
    @items.each do |item|
      if ["Tv show", "Musician/band", "Movie", "Book", "Interest", "Sport"].index(item.category)
        item_ids << item.id
      end
    end
    
    usuario_ids = []
    usuarios = Usuario.all
    usuarios.each do |usuario|
      usuario_ids << usuario.facebook_id
    end

    render :json => fql_query(usuario_ids, item_ids)
  end

  def fql_query usuario_ids, item_ids
    # client.fql_query("select page_id, uid from page_fan where uid in (528755713,100000389125405) and page_id in(select page_id from page_fan where uid = 702141098)")
    query = "select page_id, type, name, pic_square from page where page_id in (select page_id, uid from page_fan where uid in %s and page_id in %s)" % [usuario_ids.to_s.gsub('[','(').gsub(']',')'), item_ids.to_s.gsub('[','(').gsub(']',')')]
    session[:mogli_client].fql_query(query) 
  end

end
