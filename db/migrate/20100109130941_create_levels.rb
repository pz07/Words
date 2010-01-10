class CreateLevels < ActiveRecord::Migration
  def self.up
    create_table :level do |t|
      t.integer :learning_schema_id
      t.integer :level
      t.integer :day_interval
      t.string  :color
      
      t.timestamps
    end
    
    add_column :question, :level_id, :integer
    add_column :question, :last_level_update, :datetime
  end

  def self.down
    remove_column :question, :level_id
    remove_column :question, :last_level_update
    drop_table :level
  end
end
