class CreateRepetitions < ActiveRecord::Migration
  def self.up
    create_table :repetition do |t|
      t.integer :question_id, :null => false
      t.integer :user_id, :null => false
      t.timestamp :day, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :repetition if table_exists? :repetition
  end
end
