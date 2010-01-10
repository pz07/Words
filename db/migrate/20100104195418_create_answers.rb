class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answer do |t|
      t.references :question, :null => false
      t.text :text, :null => false
      t.integer :priority, :null => false, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :answer
  end
end
