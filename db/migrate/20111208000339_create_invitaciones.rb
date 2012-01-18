class CreateInvitaciones < ActiveRecord::Migration
  def self.up
    create_table :invitaciones do |t|
      t.boolean :aceptada, :default => nil
      t.integer :usuario_desde_id
      t.integer :usuario_para_id
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :invitaciones
  end
end
