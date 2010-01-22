require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  
  fixtures :lesson
  
  test "test attempt" do
    a = LearningAttempt.new lesson(:lesson01)
    
    curr = a.current 
    
    assert_equal 2, a.questions_to_learn.size
    assert_equal 0, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    
    a.wrong
    
    assert_equal 2, a.questions_to_learn.size
    assert_equal 1, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_equal curr, a.current
    
    a.wrong
    
    assert_equal 2, a.questions_to_learn.size
    assert_equal 1, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_equal curr, a.current
    
    #pytanie do powtórki
    a.correct
    
    assert_equal 1, a.questions_to_learn.size
    assert_equal 1, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_not_equal curr, a.current
    
    curr = a.current
    
    a.wrong
    
    assert_equal 1, a.questions_to_learn.size
    assert_equal 2, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_equal curr, a.current
    
    a.wrong
    
    assert_equal 1, a.questions_to_learn.size
    assert_equal 2, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_equal curr, a.current

    #2. pytanie do powtórki
    a.correct
    
    assert_equal 0, a.questions_to_learn.size
    assert_equal 2, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_not_equal curr, a.current
    
    curr = a.current
    
    a.wrong
    
    assert_equal 0, a.questions_to_learn.size
    assert_equal 3, a.questions_to_repeat.size #2 pytania i jedno dodatkowo do powtórki powtórki
    assert_equal 0, a.questions_passed.size
    assert_equal curr, a.current

    a.wrong
    
    assert_equal 0, a.questions_to_learn.size
    assert_equal 3, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_equal curr, a.current

    #do powtórki
    a.correct
    
    assert_equal 0, a.questions_to_learn.size
    assert_equal 2, a.questions_to_repeat.size
    assert_equal 0, a.questions_passed.size
    assert_not_equal curr, a.current

    curr = a.current

    a.correct
    
    assert_equal 0, a.questions_to_learn.size
    assert_equal 1, a.questions_to_repeat.size
    assert_equal 1, a.questions_passed.size
    assert_not_equal curr, a.current

    curr = a.current

    a.correct
    
    assert_equal 0, a.questions_to_learn.size
    assert_equal 0, a.questions_to_repeat.size
    assert_equal 2, a.questions_passed.size
    assert_not_equal curr, a.current


    #qid = a.skip
    
    #assert 0, a.questions_to_learn
    #assert 1, a.questions_to_repeat
    #assert 1, a.questions_passed
    
    #a.correct
    
    #assert 0, a.questions_to_learn
    #assert 0, a.questions_to_repeat
    #assert 2, a.questions_passed
  end
  
end
