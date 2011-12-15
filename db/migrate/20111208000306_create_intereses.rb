class CreateIntereses < ActiveRecord::Migration
  def self.up
    create_table :intereses do |t|
      t.string :nombre
      t.integer :facebook_id, :limit => 8
      t.string :categoria
      t.timestamps
    end
  end

  def self.down
    drop_table :intereses
  end
end
