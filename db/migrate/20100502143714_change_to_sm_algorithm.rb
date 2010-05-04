class ChangeToSmAlgorithm < ActiveRecord::Migration
  def self.up
    create_table :iteration do |t|
      t.integer :question_id, :null => false
      t.integer :iteration, :null => false
      t.float :day_interval
      t.timestamp :learning_begin, :null => false
      t.timestamp :learning_finished
      t.integer :answers_0, :null => false, :default => 0
      t.integer :answers_1, :null => false, :default => 0
      t.integer :answers_2, :null => false, :default => 0
      t.integer :answers_3, :null => false, :default => 0
      t.integer :answers_4, :null => false, :default => 0
      t.integer :answers_5, :null => false, :default => 0

      t.timestamps
    end
    
    remove_column :lesson, :learning_schema_id
    remove_column :question, :level_id
    
    #drop_table :learning_schema if table_exists? :learning_schema
    #drop_table :question_level_stat if table_exists? :question_level_stat
    #drop_table :level if table_exists? :level
    
    add_column :question, :e_factor, :float,  :default => 2.5 , :null => false
    add_column :question, :iteration, :integer, :default => 1, :null => false
    
    #Question.find(:all).each do |q|
    #  it = Iteration.new(:question => q, 
    #                     :iteration => 1, 
    #                     :day_interval => 1,
    #                     :learning_begin => Time.now,
    #                     :answers_0 => 0,
    #                     :answers_1 => 0,
    #                     :answers_2 => 0,
    #                     :answers_3 => 0,
    #                     :answers_4 => 0,
    #                     :answers_5 => 0)
    #  it.save(false)
    #end
  end

  def self.down
    remove_column :question, :iteration
    remove_column :question, :e_factor
    
    add_column :lesson, :learning_schema_id, :integer
    add_column :question, :level_id, :integer
    
    drop_table :iteration
    
  end
end
