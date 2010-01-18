class Question < ActiveRecord::Base
  
  #zależności
  belongs_to :lesson
  belongs_to :level
  
  has_many :answers, :dependent => :destroy, :order => "priority ASC"
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
  
  def correct answer
    result = nil
    answer_size = nil;
    
    answers.each do |a|
      l = levenshtein(a.text, answer);
      if !result or l < result
        result = l
        answer_size = a.text.length
      end
    end
    
    answer_size = answer.length if answer.length > answer_size
      
    if result == 0
      return 100
    elsif result >= answer_size
      return 0
    else
      return 100 - (((result/answer_size.to_f) * 100).to_i)
    end
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
      errors.add(:answer, "can't be blank" ) if (answers.nil? || answers.size == 0)
    end

  private
    def levenshtein(a, b)
      case
        when a.empty? then b.length
        when b.empty? then a.length
        else [(a[0] == b[0] ? 0 : 1) + levenshtein(a[1..-1], b[1..-1]),
              1 + levenshtein(a[1..-1], b),
              1 + levenshtein(a, b[1..-1])].min
      end
    end
end
