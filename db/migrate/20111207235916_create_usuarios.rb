class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios do |t|
      t.integer :facebook_id, :limit => 8
      t.string :genero
      t.string :email
      t.string :nombre
      t.integer :hora_lunch_inicio
      t.integer :hora_lunch_fin
      t.string :thumbnail

      t.timestamps
    end
  end

  def self.down
    drop_table :usuarios
  end
end
