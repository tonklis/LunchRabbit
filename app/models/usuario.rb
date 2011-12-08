class Usuario < ActiveRecord::Base
  has_and_belongs_to_many :intereses
  has_and_belongs_to_many :grupos

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
    usuario.save
  end

  # todo: incluir zona
  def Usuario.busqueda (facebook_id)

    usuario_origen = Usuario.find_by_facebook_id (facebook_id)
    usuarios_destino = Usuario.find(:all, :conditions => ["id <> ? and hora_inicio >= ? and hora_final <= ?", usuario_origen.id, usuario_origen.hora_inicio, usuario_origen.hora_final])
    usuarios = []
    usuarios_destino.each do |usuario|
      usuario.intereses.each do |interes|
        if usuario_origen.intereses.include?(interes)
          usuarios << usuario
          break
        end
      end
    end
    return usuarios
  end

end
