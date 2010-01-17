require 'test_helper'

class LevelTest < ActiveSupport::TestCase
  
  test "test validation" do
    level = Level.new
    
    assert !level.valid?
    assert level.errors.invalid?(:level)
    assert level.errors.invalid?(:day_interval)
    assert level.errors.invalid?(:learning_schema)
    assert level.errors.invalid?(:color)
    
    #unikalność level i learning_schema
    level.learning_schema = learning_schema(:default)
    level.level = 0
    assert !level.valid?
    assert level.errors.invalid?(:level)
    
    #muszą być liczby całkowite
    level.level = 'aa'
    level.day_interval = 'bb'
    assert !level.valid?
    assert level.errors.invalid?(:level)
    assert level.errors.invalid?(:day_interval)
    
    #format koloru
    level.level = 8
    level.day_interval = 200
    level.color = 'aa'
    assert !level.valid?
    assert !level.errors.invalid?(:level)
    assert !level.errors.invalid?(:day_interval)
    assert level.errors.invalid?(:color)
    
    level.color = '#0099FF';
    assert level.valid?
  end
  
  test "test next level" do
    level = learning_schema(:short).start_level
    
    #short1
    assert_not_nil(level = level.next_level)
    assert_equal 1, level.level
    #short2
    assert_not_nil(level = level.next_level)
    assert_equal 2, level.level
    #short3
    assert_not_nil(level = level.next_level)
    assert_equal 3, level.level
    #short4
    assert_not_nil(level = level.next_level)
    assert_equal 4, level.level
    #nil
    assert_nil(level = level.next_level)
  end
  
end
