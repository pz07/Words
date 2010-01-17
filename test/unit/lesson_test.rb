require 'test_helper'


class LessonTest < ActiveSupport::TestCase

  test "test validation" do
    lesson = Lesson.new
    
    assert !lesson.valid?
    assert lesson.errors.invalid?(:name)
    assert lesson.errors.invalid?(:learning_schema)
    assert !lesson.errors.invalid?(:description)
    
    lesson.name = ''
    assert !lesson.valid?
    assert lesson.errors.invalid?(:name)
    
    #nazwa nie jest unikalna
    lesson.name = 'Test lesson 02'
    assert !lesson.valid?
    assert lesson.errors.invalid?(:name)
    
    #nazwa ok
    lesson.name = 'Test lesson 03'
    assert !lesson.valid?
    assert !lesson.errors.invalid?(:name)
    assert lesson.errors.invalid?(:learning_schema)
    
    lesson.learning_schema = learning_schema(:default)
    assert lesson.valid?
  end
  
  test "test questions_to_learn" do
    l = lesson(:lesson01)
    
    to_learn = l.questions_to_learn
    assert_equal 2, to_learn.size
    
    q01 = question(:home) 
    q02 = question(:tree)
    
    q01.next_level
    q02.next_level
    
    q01.save!
    q02.save!
    
    l.reload
    
    to_learn = l.questions_to_learn
    assert_equal 0, to_learn.size
    
    #minęło 21 godz.
    q01.last_level_update = q01.last_level_update.advance(:hours => -21)
    q01.save!
    
    l.reload
    
    to_learn = l.questions_to_learn
    assert_equal 0, to_learn.size
    
    #minęły dodatkowe 2 godz.
    q01.last_level_update = q01.last_level_update.advance(:hours => -2)
    q01.save!
    
    l.reload
    
    to_learn = l.questions_to_learn
    assert_equal 1, to_learn.size
    
    q01.next_level
    q01.save!
    
    l.reload
    
    to_learn = l.questions_to_learn
    assert_equal 0, to_learn.size
  end
  
  test "questions deleted" do
    qid = question(:home).id
    aid = answer(:home0).id
    
    assert_nothing_raised do
      Question.find(qid)
    end
    assert_nothing_raised do
      Answer.find(aid)
    end
    
    lesson(:lesson01).destroy
    
    assert_raise ActiveRecord::RecordNotFound do
      Question.find(qid)
    end
    assert_raise ActiveRecord::RecordNotFound do
      Answer.find(aid)
    end
  end
  
end
