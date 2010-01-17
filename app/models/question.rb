class Question < ActiveRecord::Base
  
  #zależności
  belongs_to :lesson
  belongs_to :level
  
  has_many :answers, :dependent => :destroy
  has_one :first_answer,
          :class_name => 'Answer' ,
          :order  => 'priority ASC'
          

  
  #walidacja
  validates_presence_of :text, :lesson, :level, :last_level_update, :active
  validate :must_have_at_least_one_answer
  
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
      self.last_level_update = Time.now
    end
  end
  
  protected
    def must_have_at_least_one_answer
      errors.add(:answers, 'Question must have at least one answer' ) if answers.nil? || answers.size == 0
    end

  
end
