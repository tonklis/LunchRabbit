class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :intereses
  has_and_belongs_to_many :grupos
  has_many :invitaciones_enviadas, :class_name => "Invitacion", :foreign_key => "usuario_desde_id", :order => ["created_at desc limit 10"]
  has_many :invitaciones_recibidas, :class_name => "Invitacion", :foreign_key => "usuario_para_id", :order => ["created_at desc limit 10"]
  has_many :zonas

  def invitaciones_mezcladas
    invitaciones = self.invitaciones_enviadas + self.invitaciones_recibidas
    invitaciones.sort!{|a,b| b.updated_at <=> a.updated_at}[0..9]    
  end

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
    
    if intereses
      if not intereses.respond_to?('each')
        intereses = ActiveSupport::JSON.decode(intereses)
      end
      usuario.intereses = []
      intereses.each do |interes|
        interes = Interes.find_or_create_by_facebook_id(interes["facebook_id"]){|u|
                                                                                 u.nombre = interes["nombre"]
                                                                                 u.categoria = interes["categoria"]}
        usuario.intereses << interes
      end
    end
      
    if zona = params[:zona]
      usuario.zonas.destroy_all
      usuario.zonas << Zona.new(zona) 
    end

    usuario.save!
    usuario
  end

  def Usuario.busqueda (facebook_id, limit = nil)

    usuario_origen = Usuario.find_by_facebook_id (facebook_id)
    consulta = "id <> ? and ((hora_lunch_inicio >= ? and hora_lunch_fin <= ?) or (hora_lunch_inicio <= ? and hora_lunch_fin >= ?))"
    order_by = "RANDOM()"

    # todo: incluir zona

    usuarios_destino = Usuario.find(:all, :conditions => [consulta, usuario_origen.id, usuario_origen.hora_lunch_inicio, usuario_origen.hora_lunch_fin, usuario_origen.hora_lunch_inicio, usuario_origen.hora_lunch_fin], :order => order_by)
    
    usuarios_destino.each do |usuario_destino|
      usuario_destino[:intereses_comun] = {}
      usuario_destino.intereses.each do |interes_destino|
        if usuario_destino[:intereses_comun].size < 3 and usuario_origen.intereses.include?(interes_destino)
          usuario_destino[:intereses_comun][interes_destino.id] = interes_destino.nombre
        end
      end
      while usuario_destino[:intereses_comun].size < 3 and usuario_destino[:intereses_comun].size < usuario_destino.intereses.size
        interes = usuario_destino.intereses[0..10].sort_by{rand}[0]
        usuario_destino[:intereses_comun][interes.id] = interes.nombre
      end
    end

    if limit
      usuarios_destino = usuarios_destino[0..(limit-1)]
    end
    return usuarios_destino
  end

end
