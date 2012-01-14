class Interes < ActiveRecord::Base
  has_and_belongs_to_many :usuarios

  def self.to_html intereses
    html = ""
    intereses.each do |interes|
      html += "#{interes.nombre}, "
    end
    return html[0..(html.size-3)]
  end

  def self.kv_to_html lista_intereses
    html = ""
    lista_intereses.each do |key, value|
      html += "#{value}, "
    end
    return html[0..(html.size-3)]
  end

  def self.search(search)
    if search
      where('nombre LIKE ?', "#{search}%" )
    else
      scoped
    end
  end
end
