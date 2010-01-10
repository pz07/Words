class AddTestQuestions < ActiveRecord::Migration
  def self.up
    Answer.delete_all
    Question.delete_all
    
    lesson = Lesson.find_by_name('Test 01')
    
    q01 = Question.new(:lesson_id => lesson.id, :text => "Home")
    q02 = Question.new(:lesson_id => lesson.id, :text => "Tree")
    
    q01.save(false)
    q02.save(false)
    
    Answer.new(:question_id => q01.id, :text => 'Dom').save(false)
    Answer.new(:question_id => q02.id, :text => 'Drzewo').save(false)
  end

  def self.down
    Answer.delete_all
    Question.delete_all
  end
end
