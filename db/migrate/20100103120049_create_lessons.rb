class CreateLessons < ActiveRecord::Migration
  def self.up
    create_table :lesson do |t|
      t.string :name, :null => false
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :lesson
  end
end
