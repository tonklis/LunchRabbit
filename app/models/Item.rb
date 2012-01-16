class Item < Mogli::Model
  extend Mogli::Model::Search
  
  set_search_type :all
  attr_accessor :name, :id, :category, :picture

end
