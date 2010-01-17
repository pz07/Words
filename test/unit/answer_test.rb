require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  
  test "test validation" do
    a = Answer.new
    
    assert !a.valid?
    assert a.errors.invalid?(:text)
    assert a.errors.invalid?(:question)
    assert !a.errors.invalid?(:priority)
    
    a.text = 'a01'
    a.question = question(:home)
    a.priority = 'a'
    
    assert !a.valid?
    assert a.errors.invalid?(:priority)
    
    a.priority = 1.1
    
    assert !a.valid?
    assert a.errors.invalid?(:priority)
    
    a.priority = 1

    assert a.valid?
  end
  
end
