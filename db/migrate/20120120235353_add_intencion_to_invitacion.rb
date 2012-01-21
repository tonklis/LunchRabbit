class AddIntencionToInvitacion < ActiveRecord::Migration
  def self.up
    add_column :invitaciones, :intencion_id, :integer
  end

  def self.down
    remove_column :invitaciones, :intencion_id
  end
end
