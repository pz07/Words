require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  
  def setup
    @q = Question.new
    @q.lesson = lesson(:lesson01)
    @q.level = @q.lesson.learning_schema.start_level
    @q.text = "q01"
    @q.last_level_update = Time.now
    
    @a01 = Answer.new
    @a01.text = "a01"
    @a01.priority = 1
    @a01.question = @q
    
    @a02 = Answer.new
    @a02.text = "a02"
    @a02.priority = 2
    @a02.question = @q
    
    @q.answers << @a01
    @q.answers << @a02
  end
  
  test "test validation" do
    q = Question.new
    
    assert !q.valid?
    assert q.active
    assert q.errors.invalid?(:text)
    assert q.errors.invalid?(:last_level_update)
    assert q.errors.invalid?(:level)
    assert q.errors.invalid?(:lesson)
    assert q.errors.invalid?(:answer)
    
    assert @q.valid?
  end
  
  test "test first answer" do
    @q.save
    
    assert_equal "a01", @q.first_answer.text
    
    @a01.priority = 3
    @a01.save
    
    @q.reload
    
    assert_equal "a02", @q.first_answer.text
  end
  
  test "test correct?" do
     assert @q.correct?("a01")
     assert @q.correct?("a02")
     assert !@q.correct?("a03")
 end
 
 test "test correct" do
     assert_equal 100, @q.correct("a01")
     assert_equal 100, @q.correct("a02")
     assert_equal 67, @q.correct("a03")
     assert_equal 0, @q.correct("")
     assert_equal 34, @q.correct("a")
     assert_equal 67, @q.correct("002")
     assert_equal 50, @q.correct("a01000")
 end
 
 test "test next_level" do
   t = @q.last_level_update
  
   assert_equal 0, @q.level.level
   assert @q.active
  
   @q.next_level
   assert_equal 1, @q.level.level
   assert @q.last_level_update > t
   assert @q.active
   t = @q.last_level_update
   
   @q.next_level
   assert_equal 2, @q.level.level
   assert @q.last_level_update > t
   assert @q.active
   t = @q.last_level_update
   
   @q.next_level
   assert_equal 3, @q.level.level
   assert @q.last_level_update > t
   assert @q.active
   t = @q.last_level_update
   
   @q.next_level
   assert_equal 4, @q.level.level
   assert @q.last_level_update > t
   assert @q.active
   t = @q.last_level_update
   
   @q.next_level
   assert_equal 5, @q.level.level
   assert @q.last_level_update > t
   assert @q.active
   t = @q.last_level_update
   
   @q.next_level
   assert_equal 6, @q.level.level
   assert @q.last_level_update > t
   assert @q.active
   t = @q.last_level_update
   
   @q.next_level
   assert_equal 7, @q.level.level
   assert @q.last_level_update > t
   assert @q.active
   t = @q.last_level_update
   
   @q.next_level
   assert_equal 7, @q.level.level
   assert @q.last_level_update == t
   assert !@q.active
 end

 test "answers deleted" do
    aid = answer(:home0).id
    
    assert_nothing_raised do
      Answer.find(aid)
    end
    
    question(:home).destroy
    
    assert_raise ActiveRecord::RecordNotFound do
      Answer.find(aid)
    end
 end
end
