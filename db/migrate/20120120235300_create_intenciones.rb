class CreateIntenciones < ActiveRecord::Migration
  def self.up
    create_table :intenciones do |t|
      t.string :nombre

      t.timestamps
    end
  end

  def self.down
    drop_table :intenciones
  end
end
