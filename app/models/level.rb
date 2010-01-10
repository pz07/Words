class Level < ActiveRecord::Base
  
  #zależności
  belongs_to :learning_schema
  
  #walidacja
  validates_presence_of :level, :color, :day_interval
  validates_presence_of :learning_schema
  validates_numericality_of(:level, :message => "Level should be number!")
  
  def next_level 
    Level.find(:first,
               :order => "level ASC",
               :conditions => [ "learning_schema_id = ? and level > ?", learning_schema.id, level])  
  end
  
end
