class Interes < ActiveRecord::Base
  has_and_belongs_to_many :usuarios

  def Interes.to_html intereses
    html = ""
    intereses.each do |interes|
      html += "#{interes.nombre}, "
    end
    return html[0..(html.size-3)]
  end
end
