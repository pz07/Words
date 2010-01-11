class Question < ActiveRecord::Base
  
  #zależności
  belongs_to :lesson
  belongs_to :level
  
  has_many :answers
  has_one :first_answer,
          :class_name => 'Answer' ,
          :order  => 'priority ASC'
          

  
  #walidacja
  validates_presence_of :text
  validates_presence_of :lesson
  validates_presence_of :level
  validates_presence_of :last_level_update
  
  def correct? answer
    answers.each do |a|
      if a.text == answer
        return a
      end
    end
    
    return nil
  end
  
  def next_level
    n = self.level.next_level
    if n == nil
      self.active = false
    else
      self.level = n 
    end
    
    self.last_level_update = Time.now
  end
  
end
