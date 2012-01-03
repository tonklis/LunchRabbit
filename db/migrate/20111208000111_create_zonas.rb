class CreateZonas < ActiveRecord::Migration
  def self.up
    create_table :zonas do |t|
      t.integer :usuario_id
      t.string :nombre
      t.float :longitude
      t.float :latitude
      t.float :radio

      t.timestamps
    end
  end

  def self.down
    drop_table :zonas
  end
end
