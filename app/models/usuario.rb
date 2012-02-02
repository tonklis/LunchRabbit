class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :validatable, :database_authenticatable
  devise :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  has_and_belongs_to_many :intereses
  has_and_belongs_to_many :grupos
  has_many :invitaciones_enviadas, :class_name => "Invitacion", :foreign_key => "usuario_desde_id", :order => ["created_at desc"]
  has_many :invitaciones_recibidas, :class_name => "Invitacion", :foreign_key => "usuario_para_id", :order => ["created_at desc"]
  has_many :zonas

  KILOMETER_TO_MILE = 0.62

  def password_required?
    false
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource = nil)
    data = access_token.extra.raw_info
    encuentra_o_crea(data.id, data.email, access_token.credentials.token)
  end

  def self.find_facebook_user token
    begin
      Mogli::User.find("me", Mogli::Client.new(token))
    rescue
      raise "User session expired"
    end
  end

  validates_numericality_of :hora_lunch_fin, :greater_than => Proc.new { |r| r.hora_lunch_inicio }, :allow_blank => true

  def invitaciones_mezcladas
    invitaciones = self.invitaciones_enviadas + self.invitaciones_recibidas
    invitaciones.sort!{|a,b| b.updated_at <=> a.updated_at}[0..9]    
  end

  def self.sincroniza_con_facebook usuario, token
    
      fb_user = Usuario.find_facebook_user(token)
      usuario.thumbnail = "https://graph.facebook.com/#{fb_user.id}/picture?type=normal"  
 
      usuario.intereses = []
      intereses = fb_user.likes
      intereses.each do |interes|
        #if ["Tv show", "Musician/band", "Movie", "Book", "Interest", "Sport"].index(interes.category)
          usuario.intereses << Interes.find_or_create_by_facebook_id(interes.id){|u|
            u.nombre = interes.name
            u.categoria = interes.category}
        #end 
      end
  end

  def self.encuentra_o_crea (facebook_id, email=nil, access_token=nil)
    usuario = Usuario.find_by_facebook_id facebook_id
    if not usuario
      usuario = Usuario.new
      usuario.facebook_id = facebook_id
      if email 
        usuario.email = email
      end 
      usuario.save
    end
    if access_token 
      sincroniza_con_facebook(usuario, access_token)
    end
    return usuario
  end
 
  
  def self.actualiza (params)

    usuario = Usuario.find_by_facebook_id (params[:id])
    usuario.update_attributes(params[:usuario])

    if params[:actualiza] == "true"

      sincroniza_con_facebook(usuario, params[:at])

    elsif intereses = params[:intereses]
      
      usuario.intereses = []
      intereses.each do |interes|
        usuario.intereses << Interes.find_or_create_by_facebook_id(interes["facebook_id"]){|u|
          u.nombre = interes["nombre"]
          u.categoria = interes["categoria"]
        }
      end
    end
      
    if params[:zona]

      begin
        # WEB
        zona = ActiveSupport::JSON.decode(params[:zona])
      rescue
        # MOVIL
        zona = params[:zona]
      end

      uz = usuario.zonas.where("nombre = '#{zona["nombre"]}'").first
      if uz.nil?
        usuario.zonas << Zona.new(zona)
      else
        uz.update_attributes(zona)
      end
    end

    usuario.save!
    usuario
  end

  def self.busqueda_por_interes (interes_id)
   # todo: hacer esta funcionalidad 
  end

  def self.busqueda (facebook_id, limit = nil, interes_id = nil)

    usuario_origen = Usuario.find_by_facebook_id (facebook_id)
    zona_origen = usuario_origen.zonas.first
    hora_inicial = usuario_origen.hora_lunch_inicio
    hora_final = usuario_origen.hora_lunch_fin
    diferencia_hora = hora_final - hora_inicial

    consulta = "id <> #{usuario_origen.id}
                AND #{hora_inicial + diferencia_hora} >= hora_lunch_inicio AND #{hora_final - diferencia_hora} <= hora_lunch_fin
                AND #{hora_final} > hora_lunch_inicio AND #{hora_inicial} < hora_lunch_fin"

    usuarios_interes_comun = []
    usuarios_sin_interes_comun = []

    usuarios_destino = Usuario.find(:all, :conditions => consulta, :order => ORDER_BY )
    
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
