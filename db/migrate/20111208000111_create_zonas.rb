class CreateZonas < ActiveRecord::Migration
  def self.up
    create_table :zonas do |t|
      t.integer :usuario_id
      t.string :nombre
      t.float :longitud
      t.float :latitud
      t.integer :radio

      t.timestamps
    end
  end

  def self.down
    drop_table :zonas
  end
end
