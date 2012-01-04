class Zona < ActiveRecord::Base
  belongs_to :usuario
  geocoded_by :nombre
end
