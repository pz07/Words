class AddTestLessons < ActiveRecord::Migration
  def self.up
    Lesson.delete_all
    
    Lesson.new(:name => "Test 01", :description => "Test lesson number 01").save(false)
    Lesson.new(:name => "Test 02", :description => "Test lesson number 02").save(false)
  end

  def self.down
    Lesson.delete_all
  end
end
