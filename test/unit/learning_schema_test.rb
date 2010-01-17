require 'test_helper'

class LearningSchemaTest < ActiveSupport::TestCase
  
  test "test validation" do
    schema = LearningSchema.new
    
    assert !schema.valid?
    assert schema.errors.invalid?(:name)
    assert schema.errors.invalid?(:levels)
    assert !schema.errors.invalid?(:description)
    
    #unikalność nazwy
    schema.name = 'default'
    assert !schema.valid?
    assert schema.errors.invalid?(:name)
    
    schema.name = 'test'
    assert !schema.valid?
    assert !schema.errors.invalid?(:name)
    assert schema.errors.invalid?(:levels)
    
    level = Level.new(:level => 0, :day_interval => 0, :color => '#000000', :learning_schema => schema)
    
    schema.levels << level
    assert schema.valid?
  end
  
  test "levels destroyed" do
    lid = level(:default0)
    
    assert_nothing_raised do
      Level.find(lid)
    end
    
    learning_schema(:default).destroy
    
    assert_raise ActiveRecord::RecordNotFound do
      Level.find(lid)
    end
  end
end
