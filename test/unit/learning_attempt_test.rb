require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  
  fixtures :lesson
  
  test "test attempt" do
    a = LearningAttempt.new lesson(:lesson01)
    assert 2, a.questions_to_learn
    assert 0, a.questions_to_repeat
    assert 0, a.questions_passed
    
    a.correct
    
    assert 1, a.questions_to_learn
    assert 0, a.questions_to_repeat
    assert 1, a.questions_passed
    
    a.wrong
    
    assert 0, a.questions_to_learn
    assert 1, a.questions_to_repeat
    assert 1, a.questions_passed
    
    a.wrong
    
    assert 0, a.questions_to_learn
    assert 1, a.questions_to_repeat
    assert 1, a.questions_passed
    
    qid = a.skip
    
    assert 0, a.questions_to_learn
    assert 1, a.questions_to_repeat
    assert 1, a.questions_passed
    
    a.correct
    
    assert 0, a.questions_to_learn
    assert 0, a.questions_to_repeat
    assert 2, a.questions_passed
  end
  
end
