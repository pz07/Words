class Question < ActiveRecord::Base
  
  #zależności
  belongs_to :lesson
  belongs_to :level
  
  has_many :answers, :dependent => :destroy, :order => "priority ASC"
  has_many :question_level_stats, :dependent => :destroy, :order => "created_at ASC"
  has_one :first_answer,
          :class_name => 'Answer' ,
          :order  => 'priority ASC'
          
  #walidacja
  validates_presence_of :text, :lesson, :level, :last_attempt_date
  validates_inclusion_of :active, :in => [true, false] 
  validate :must_have_at_least_one_answer
  
  def before_save
    if !self.id or !QuestionLevelStat.find_by_question_id_and_level_id(self.id, self.level.id)
      self.question_level_stats << QuestionLevelStat.new(:question => self, :level => self.level, 
                    :learning_begin => Time.now, :correct_answers => 0, :wrong_answers => 0)
    end
  end
  
  def current_level_stats
    QuestionLevelStat.find(:first, :conditions => ["level_id = ? and question_id = ?", self.level.id, self.id])
  end
  
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
  
  def correct_answer
    Question.transaction do
      stats = self.current_level_stats
      stats.correct_answers = stats.correct_answers.next
      stats.learning_finished = Time.now
      
      stats.save!
      
      n = self.level.next_level
      if n == nil
        self.active = false
      else
        self.level = n 
        self.last_attempt_date = Time.now
        self.next_attempt_date = compute_next_attempt_date
      end
      
      self.save!
    end
  end
  
  def wrong_answer
    stats = self.current_level_stats
    stats.wrong_answers = stats.wrong_answers.next
    
    stats.save!
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
