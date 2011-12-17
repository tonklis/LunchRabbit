class AddEmailToUsuarios < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :email, :string
  end

  def self.down
    remove_column :usuarios, :email 
  end
end
