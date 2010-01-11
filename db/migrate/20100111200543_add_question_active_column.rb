class AddQuestionActiveColumn < ActiveRecord::Migration
  def self.up
    add_column :question, :active, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :question, :active
  end
end
