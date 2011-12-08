class CreateGruposUsuariosJoin < ActiveRecord::Migration
  def self.up
    create_table 'grupos_usuarios', :id => false do |t|
      t.column 'grupo_id', :integer
      t.column 'usuario_id', :integer
    end
  end

  def self.down
    drop_table 'grupos_usuarios'
  end
end
