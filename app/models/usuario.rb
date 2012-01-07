class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :intereses
  has_and_belongs_to_many :grupos
  has_many :invitaciones_enviadas, :class_name => "Invitacion", :foreign_key => "usuario_desde_id", :order => ["created_at desc"]
  has_many :invitaciones_recibidas, :class_name => "Invitacion", :foreign_key => "usuario_para_id", :order => ["created_at desc"]
  has_many :zonas

  KILOMETER_TO_MILE = 0.62

  validates_numericality_of :hora_lunch_fin, :greater_than => Proc.new { |r| r.hora_lunch_inicio }, :allow_blank => true

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
      intereses = ActiveSupport::JSON.decode(intereses)
      usuario.intereses = []
      intereses.each do |interes|
        usuario.intereses << Interes.find_or_create_by_facebook_id(interes["interes"]["facebook_id"]){|u|
          u.nombre = interes["interes"]["nombre"]
          u.categoria = interes["interes"]["categoria"]
        }
      end
    end
      
    if zona = params[:zona]
      uz = usuario.zonas.where("nombre = 'web'").first
      uz.update_attributes(ActiveSupport::JSON.decode(zona))
    end

    usuario.save!
    usuario
  end

  def Usuario.busqueda (facebook_id, limit = nil)

    usuario_origen = Usuario.find_by_facebook_id (facebook_id)
    zona_origen = usuario_origen.zonas.first
    consulta = "id <> ? and ((hora_lunch_inicio >= ? and hora_lunch_fin <= ?) or (hora_lunch_inicio <= ? and hora_lunch_fin >= ?))"
    # VERSION_PROD
    order_by = "RANDOM()"
    # order_by = "RAND()"
    usuarios_interes_comun = []
    usuarios_sin_interes_comun = []

    usuarios_destino = Usuario.find(:all, :conditions => [consulta, usuario_origen.id, usuario_origen.hora_lunch_inicio, usuario_origen.hora_lunch_fin, usuario_origen.hora_lunch_inicio, usuario_origen.hora_lunch_fin], :order => order_by)
    #usuarios_destino = Usuario.all

    usuarios_destino.each do |usuario_destino|    
      zona_destino = usuario_destino.zonas.first
      usuario_destino[:distancia] = zona_destino.distance_from([zona_origen.latitude, zona_origen.longitude]).round(2)
      # si esta fuera del rango, avanzar al siguiente usuario
      next if usuario_destino[:distancia] > (zona_origen.radio + zona_destino.radio) * KILOMETER_TO_MILE

      # se registra para dar preferencia a usuarios que tienen intereses en comun
      interes_comun = false
      usuario_destino[:lista_intereses] = {}
      # se priorizan por orden los intereses en comun
      usuario_destino.intereses.each do |interes_destino|
        if usuario_destino[:lista_intereses].size < 3 and usuario_origen.intereses.include?(interes_destino)
          usuario_destino[:lista_intereses][interes_destino.id] = interes_destino.nombre
          interes_comun = true
        end
      end
      while usuario_destino[:lista_intereses].size < 3 and usuario_destino[:lista_intereses].size < usuario_destino.intereses.size
        interes = usuario_destino.intereses[0..10].sort_by{rand}[0]
        usuario_destino[:lista_intereses][interes.id] = interes.nombre
      end

      if interes_comun
        usuarios_interes_comun << usuario_destino
      else
        usuarios_sin_interes_comun << usuario_destino
      end
    end

    usuarios_result = []
    # todo: ordenar por numero de intereses en comun y despues por distancia
    usuarios_result += usuarios_interes_comun.sort_by{rand}
    # todo: ordenar por distancia
    usuarios_result += usuarios_sin_interes_comun.sort_by{rand}

    if limit.nil?
      usuarios_result = usuarios_result.take(3)
    else
      usuarios_result = usuarios_result.take(limit.to_i)
    end
    return usuarios_result
  end

end
