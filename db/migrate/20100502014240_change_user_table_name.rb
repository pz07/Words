class ChangeUserTableName < ActiveRecord::Migration
  def self.up
     rename_table :user, :users if table_exists? :user
  end

  def self.down
    rename_table :users, :user if table_exists? :users
  end
end
