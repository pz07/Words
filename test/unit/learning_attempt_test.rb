require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  
  fixtures :lesson
  
  test "test attempt" do
    a = LearningAttempt.new lesson(:lesson01)
    assert 2, a.questions_to_learn
    assert 0, a.questions_to_repeat
    assert 0, a.questions_passed
    
    qid = a.questions_to_learn[0]
    a.correct qid
    
    assert 1, a.questions_to_learn
    assert 0, a.questions_to_repeat
    assert 1, a.questions_passed
    
    qid = a.questions_to_learn[0]
    a.wrong qid
    
    assert 0, a.questions_to_learn
    assert 1, a.questions_to_repeat
    assert 1, a.questions_passed
    
    qid = a.questions_to_repeat[0]
    a.wrong qid
    
    assert 0, a.questions_to_learn
    assert 1, a.questions_to_repeat
    assert 1, a.questions_passed
    
    qid = a.questions_to_repeat[0]
    a.correct qid
    
    assert 0, a.questions_to_learn
    assert 0, a.questions_to_repeat
    assert 2, a.questions_passed
  end
  
end
