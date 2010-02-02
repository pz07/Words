class Level < ActiveRecord::Base
  
  #zależności
  belongs_to :learning_schema
  
  #walidacja
  validates_presence_of :level, :color, :day_interval, :learning_schema
  validates_numericality_of :level, :day_interval, :only_integer => true
  validates_uniqueness_of :level, :scope => :learning_schema_id
  validates_format_of :color, :with => /^#[0-9A-F]{6}$/
  
  def next_level 
    Level.find(:first,
               :order => "level ASC",
               :conditions => [ "learning_schema_id = ? and level > ?", learning_schema.id, level])  
  end
  
  def prev_level 
    Level.find(:first,
               :order => "level DESC",
               :conditions => [ "learning_schema_id = ? and level < ?", learning_schema.id, level])  
  end
  
end
