class CreateLearningSchemas < ActiveRecord::Migration
  def self.up
    create_table :learning_schema do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    
    add_column :lesson, :learning_schema_id, :integer
  end

  def self.down
    remove_column :lesson, :learning_schema_id
    drop_table :learning_schema
  end
end
