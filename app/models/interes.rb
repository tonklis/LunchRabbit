class Interes < ActiveRecord::Base
  has_and_belongs_to_many :usuarios

  def Interes.to_html intereses
    html = ""
    intereses.each do |interes|
      html += "#{interes.nombre}, "
    end
    return html[0..(html.size-3)]
  end

  def Interes.kv_to_html lista_intereses
    html = ""
    lista_intereses.each do |key, value|
      html += "#{value}, "
    end
    return html[0..(html.size-3)]
  end
end
