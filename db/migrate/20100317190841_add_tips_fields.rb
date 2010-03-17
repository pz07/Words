class AddTipsFields < ActiveRecord::Migration
  def self.up
     add_column :question, :question_tip, :string, :null => true
     add_column :question, :answer_tip, :string, :null => true
     
     add_column :answer, :tip, :string, :null => true
  end

  def self.down
     remove_column :question, :question_tip
     remove_column :question, :answer_tip
     
     remove_column :answer, :tip
  end
end
