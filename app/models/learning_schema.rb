class LearningSchema < ActiveRecord::Base
  
  #zależności
  has_many :levels
  has_one :start_level, :class_name => 'Level', :order  => 'level ASC'
  has_one :last_level, :class_name => 'Level' , :order  => 'level DESC'
  
  #walidacja
  validates_presence_of :name
  validates_uniqueness_of :name
end
