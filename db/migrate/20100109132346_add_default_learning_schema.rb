class AddDefaultLearningSchema < ActiveRecord::Migration
  def self.up
    Level.delete_all
    LearningSchema.delete_all
    
    schema = LearningSchema.new(:name => 'default', :description => "Default learning schema")
    schema.save false
    
    level00 = Level.create!(:learning_schema => schema, :level => 0, :day_interval => 0, :color => '#000000')
    Level.create!(:learning_schema => schema, :level => 1, :day_interval => 1, :color => '#BF3B3B')
    Level.create!(:learning_schema => schema, :level => 2, :day_interval => 2, :color => '#DF1B1B')
    Level.create!(:learning_schema => schema, :level => 3, :day_interval => 4, :color => '#FF0000')
    Level.create!(:learning_schema => schema, :level => 4, :day_interval => 7, :color => '#D0AB00')
    Level.create!(:learning_schema => schema, :level => 5, :day_interval => 21, :color => '#FFBF00')
    Level.create!(:learning_schema => schema, :level => 6, :day_interval => 60, :color => '#01B600')
    Level.create!(:learning_schema => schema, :level => 7, :day_interval => 120, :color => '#00F02D')
    
    schema.reload
    level00.reload

    Lesson.reset_column_information
    Question.reset_column_information

    Lesson.find(:all).each do |lesson|
      lesson.update_attributes(:learning_schema => schema)
      lesson.save!
    end
    
    Question.find(:all).each do |q|
      q.level = level00
      q.last_level_update = Time.now
      q.save(false)
    end
  end

  def self.down
    Level.delete_all
    LearningSchema.delete_all
  end
end
