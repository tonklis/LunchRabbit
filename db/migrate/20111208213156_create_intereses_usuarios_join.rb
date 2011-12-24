class CreateInteresesUsuariosJoin < ActiveRecord::Migration

  def self.up
    create_table 'intereses_usuarios', :id => false do |t|
      t.column 'interes_id', :integer
      t.column 'usuario_id', :integer
    end

    add_index :intereses_usuarios, [:interes_id, :usuario_id], :unique => true 
  end

  def self.down
    drop_table 'intereses_usuarios'
  end

end
