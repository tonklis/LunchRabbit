class CreateInvitaciones < ActiveRecord::Migration
  def self.up
    create_table :invitaciones do |t|
      t.boolean :aceptada
      t.integer :usuario_desde_id
      t.integer :usuario_para_id

      t.timestamps
    end
    add_index :invitaciones, [:usuario_desde_id, :usuario_para_id], :unique => true
  end

  def self.down
    drop_table :invitaciones
  end
end
