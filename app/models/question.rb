class Question < ActiveRecord::Base
  
  #zależności
  belongs_to :lesson
  
  has_many :answers, :dependent => :destroy, :order => "priority ASC"
  has_many :iterations, :dependent => :destroy, :order => "created_at ASC"
  has_one :first_answer,
          :class_name => 'Answer' ,
          :order  => 'priority ASC'
          
  #walidacja
  validates_presence_of :text, :lesson, :last_attempt_date
  validates_inclusion_of :active, :in => [true, false] 
  validate :must_have_at_least_one_answer
  
  def correct? answer
    answer.strip! if answer
    
    answers.each do |a|
      if a.text.strip == answer
        return a
      end
    end
    
    return nil
  end
  
  def correct answer
    answer.strip! if answer
    
    result = nil
    answer_size = nil;
    
    answers.each do |a|
      l = levenshtein(a.text.strip, answer);
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
  
  def check note
    Question.transaction do
      ci = self.current_iteration
      
      if note == 0 then
        ci.answers_0 = (ci.answers_0+1)
      elsif note == 1 then
        ci.answers_1 = (ci.answers_1+1)
      elsif note == 2 then
        ci.answers_2 = (ci.answers_2+1)
      elsif note == 3 then
        ci.answers_3 = (ci.answers_3+1)
      elsif note == 4 then
        ci.answers_4 = (ci.answers_4+1)
      elsif note == 5 then
        ci.answers_5 = (ci.answers_5+1)
      end
      
      ci.save!
      
      if note < 3 then
        self.iteration = 1
        self.next_attempt_date = Time.now.advance(:days => self.current_iteration.day_interval)
      else
        #EF+(0.1-(5-q)*(0.08+(5-q)*0.02))
        self.e_factor = self.e_factor + (0.1 - (5-note)*(0.08 + (5 - note)*0.02))
      
        if self.e_factor < 1.3
          self.e_factor = 1.3
        end
      
        ni = self.next_iteration
        self.iteration = ni.iteration
        
        if ni.iteration == 2
          ni.day_interval = 4
        else
          ni.day_interval = (self.e_factor * ci.day_interval).floor  
        end
        
        ni.save!
        
        self.next_attempt_date = Time.now.advance(:days => ni.day_interval)
      end
      
      self.save!
    end
  end
  
  def current_iteration
    Iteration.find_by_question_id_and_iteration(self.id, self.iteration)
  end
  
  def next_iteration
    n = Iteration.find_by_question_id_and_iteration(self.id, (self.iteration+1))
    if !n then
      n = Iteration.new
      n.question = self
      n.iteration= (self.iteration+1)
      n.learning_begin = Time.now
      n.answers_0 = 0
      n.answers_1 = 0
      n.answers_2 = 0
      n.answers_3 = 0
      n.answers_4 = 0
      n.answers_5 = 0
      
      n.save!
    end
    
    return n
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
