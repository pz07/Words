class Question < ActiveRecord::Base
  
  #zależności
  belongs_to :lesson
  belongs_to :level
  
  has_many :answers, :dependent => :destroy, :order => "priority ASC"
  has_one :first_answer,
          :class_name => 'Answer' ,
          :order  => 'priority ASC'
          
  #walidacja
  validates_presence_of :text, :lesson, :level, :last_attempt_date, :active
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
      self.last_attempt_date = Time.now
      self.next_attempt_date = compute_next_attempt_date
    end
  end
  
  def compute_next_attempt_date
    2.hours.ago(self.last_attempt_date.advance(:days => self.level.day_interval)) 
  end
  
  protected
    def must_have_at_least_one_answer
      errors.add(:answer, "can't be blank" ) if (answers.nil? || answers.size == 0)
    end

  private
    def levenshtein(a, b)
      distance = [];
 
      0.upto(a.length) do |i|
        distance << [i]  
      end
      0.upto(b.length) do |i|
        distance[0] << i  
      end
    
      1.upto(a.length) do |i|
        1.upto(b.length) do |j|
          distance[i][j] = [distance[i-1][j] + 1,
                            distance[i][j-1] + 1,
                            distance[i-1][j-1] + (a[i-1] == b[j-1] ? 0 : 1)].min
        end 
      end
      
      distance[a.length][b.length]
    end
end
