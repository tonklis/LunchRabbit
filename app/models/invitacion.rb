class Invitacion < ActiveRecord::Base
  belongs_to :usuario_desde, :class_name => "Usuario", :foreign_key => :usuario_desde_id
  belongs_to :usuario_para, :class_name => "Usuario", :foreign_key => :usuario_para_id

  def Invitacion.por_usuario (facebook_id)
    invitaciones = {}
    usuario = Usuario.find(facebook_id)
    invitaciones[:invitaciones_enviadas] = usuario.invitaciones_enviadas
    invitaciones[:invitaciones_recibidas] = usuario.invitaciones_recibidas

    return invitaciones
  end

  def Invitacion.desde_para (desde_facebook_id, para_facebook_id)

    invitacion = Invitacion.new(:usuario_desde => Usuario.find_by_facebook_id(desde_facebook_id), :usuario_para => Usuario.find_by_facebook_id(para_facebook_id), :aceptada => false)
    invitacion.save!

    return invitacion
  end

  def Invitacion.acepta (invitacion_id)
    invitacion = Invitacion.find(invitacion_id)
    invitacion.aceptada = true;
    invitacion.save!
    return invitacion
  end

  def Invitacion.rechaza (invitacion_id)
    invitacion = Invitacion.find(invitacion_id)
    invitacion.destroy 
  end

end
