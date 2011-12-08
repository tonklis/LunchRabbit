class Invitacion < ActiveRecord::Base
  belongs_to :usuario_desde, :class_name => "Usuario", :foreign_key => :usuario_desde_id
  belongs_to :usuario_para, :class_name => "Usuario", :foreign_key => :usuario_para_id
end
