class AddActiveColumn < ActiveRecord::Migration
  def self.up
      add_column :lesson, :active, :boolean, :null => false, :default => true
  end

  def self.down
     remove_column :lesson, :active
  end
end
