class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :question do |t|
      t.references :lesson, :null => false
      t.text :text, :nil => false

      t.timestamps
    end
  end

  def self.down
    drop_table :question
  end
end
