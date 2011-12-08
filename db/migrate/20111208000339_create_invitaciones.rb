class CreateInvitaciones < ActiveRecord::Migration
  def self.up
    create_table :invitaciones do |t|
      t.boolean :aceptada
      t.integer :usuario_desde
      t.integer :usuario_para

      t.timestamps
    end
  end

  def self.down
    drop_table :invitaciones
  end
end
