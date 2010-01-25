require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  
  def setup
    @q = Question.new
    @q.lesson = lesson(:lesson01)
    @q.level = @q.lesson.learning_schema.start_level
    @q.text = "q01"
    @q.last_attempt_date = Time.now
    
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
    assert q.errors.invalid?(:last_attempt_date)
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
     assert_equal 50, @q.correct("a02000")
     assert_equal 34, @q.correct("a03000")
 end
 
 test "test next_level" do
   @q.save!
   
   t = @q.last_attempt_date
  
   assert_equal 0, @q.level.level
   assert @q.active
  
   @q.correct_answer
   assert_equal 1, @q.level.level
   assert @q.last_attempt_date > t
   assert @q.active
   t = @q.last_attempt_date
   
   @q.correct_answer
   assert_equal 2, @q.level.level
   assert @q.last_attempt_date > t
   assert @q.active
   t = @q.last_attempt_date
   
   @q.correct_answer
   assert_equal 3, @q.level.level
   assert @q.last_attempt_date > t
   assert @q.active
   t = @q.last_attempt_date
   
   @q.correct_answer
   assert_equal 4, @q.level.level
   assert @q.last_attempt_date > t
   assert @q.active
   t = @q.last_attempt_date
   
   @q.correct_answer
   assert_equal 5, @q.level.level
   assert @q.last_attempt_date > t
   assert @q.active
   t = @q.last_attempt_date
   
   @q.correct_answer
   assert_equal 6, @q.level.level
   assert @q.last_attempt_date > t
   assert @q.active
   t = @q.last_attempt_date
   
   @q.correct_answer
   assert_equal 7, @q.level.level
   assert @q.last_attempt_date > t
   assert @q.active
   t = @q.last_attempt_date
   
   @q.correct_answer
   assert_equal 7, @q.level.level
   assert @q.last_attempt_date == t
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
 
 test "question level stats" do
   @q.save!
   
   assert_equal 1, @q.question_level_stats.length
   assert_equal 0, @q.question_level_stats[0].correct_answers
   assert_equal 0, @q.question_level_stats[0].wrong_answers
   
   stat01 = @q.current_level_stats.id
   
   @q.correct_answer
   @q.reload
   
   assert_equal 2, @q.question_level_stats.length
   assert_equal 1, @q.question_level_stats[0].correct_answers
   assert_equal 0, @q.question_level_stats[0].wrong_answers
   assert_equal 0, @q.question_level_stats[1].correct_answers
   assert_equal 0, @q.question_level_stats[1].wrong_answers
   
   stat02 = @q.current_level_stats.id
   assert_not_equal stat01, stat02

   @q.text = "bla bla bla"
   @q.save!

   @q.reload
   
   assert_equal 2, @q.question_level_stats.length

   stat03 = @q.current_level_stats.id
   assert_equal stat02, stat03
   
   @q.wrong_answer
   @q.reload
   
   assert_equal 2, @q.question_level_stats.length
   assert_equal 1, @q.question_level_stats[0].correct_answers
   assert_equal 0, @q.question_level_stats[0].wrong_answers
   assert_equal 0, @q.question_level_stats[1].correct_answers
   assert_equal 1, @q.question_level_stats[1].wrong_answers
   
   @q.wrong_answer
   @q.reload
   
   assert_equal 2, @q.question_level_stats.length
   assert_equal 1, @q.question_level_stats[0].correct_answers
   assert_equal 0, @q.question_level_stats[0].wrong_answers
   assert_equal 0, @q.question_level_stats[1].correct_answers
   assert_equal 2, @q.question_level_stats[1].wrong_answers
   
   @q.correct_answer
   @q.reload
   
   assert_equal 3, @q.question_level_stats.length
   assert_equal 1, @q.question_level_stats[0].correct_answers
   assert_equal 0, @q.question_level_stats[0].wrong_answers
   assert_equal 1, @q.question_level_stats[1].correct_answers
   assert_equal 2, @q.question_level_stats[1].wrong_answers
   assert_equal 0, @q.question_level_stats[2].correct_answers
   assert_equal 0, @q.question_level_stats[2].wrong_answers
 end
 
end
