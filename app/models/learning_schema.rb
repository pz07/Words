class LearningSchema < ActiveRecord::Base
  
  #zależności
  has_many :levels, :dependent => :destroy
  has_one :start_level, :class_name => 'Level', :order  => 'level ASC'
  has_one :last_level, :class_name => 'Level' , :order  => 'level DESC'
  
  #walidacja
  validates_presence_of :name
  validates_uniqueness_of :name
  validate :must_have_at_least_one_level
  
  protected
    def must_have_at_least_one_level
      errors.add(:levels, 'Learning schema must have at least one level' ) if levels.nil? || levels.size == 0
    end

end
