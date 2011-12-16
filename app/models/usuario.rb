class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :intereses
  has_and_belongs_to_many :grupos
  has_many :invitaciones_enviadas, :class_name => "Invitacion", :foreign_key => "usuario_desde_id", :order => ["created_at desc limit 10"]
  has_many :invitaciones_recibidas, :class_name => "Invitacion", :foreign_key => "usuario_para_id", :order => ["created_at desc limit 10"]
  has_many :zonas

  def Usuario.encuentra_o_crea (facebook_id)
    usuario = Usuario.find_by_facebook_id facebook_id
    if not usuario
      usuario = Usuario.new
      usuario.facebook_id = facebook_id
      usuario.save
    end
    return usuario
  end
  
  def Usuario.actualiza (params)

    usuario = Usuario.find_by_facebook_id (params[:id])
    usuario.update_attributes(params[:usuario])
    intereses = params[:intereses]
    usuario.intereses = []
    if intereses
      intereses.each do |interes|
        usuario.intereses << Interes.find(interes[:id])
      end
    end
    usuario.save!
    usuario
  end

  def Usuario.busqueda (facebook_id, limit = nil)

    usuario_origen = Usuario.find_by_facebook_id (facebook_id)
    consulta = "id <> ? and ((hora_lunch_inicio >= ? and hora_lunch_fin <= ?) or (hora_lunch_inicio <= ? and hora_lunch_fin >= ?))"
    order_by = "RAND()"

    # todo: incluir zona

    usuarios_destino = Usuario.find(:all, :conditions => [consulta, usuario_origen.id, usuario_origen.hora_lunch_inicio, usuario_origen.hora_lunch_fin, usuario_origen.hora_lunch_inicio, usuario_origen.hora_lunch_fin], :order => order_by)

    # todo: inteligencia de intereses (prioridad a los que se tienen en comun)
    #usuarios = []
    #usuarios_destino.each do |usuario|
    #  usuario.intereses.each do |interes|
    #    if usuario_origen.intereses.include?(interes)
    #      usuarios << usuario
    #      break
    #    end
    #  end
    #end
    
    # todo: revisar desempeño para limit
    if limit
      usuarios_destino = usuarios_destino[0..2]
    end
    return usuarios_destino
  end

end
