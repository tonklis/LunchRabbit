class Zona < ActiveRecord::Base
  acts_as_gmappable
  belongs_to :usuario
end
