class LearningAttempt
  
  attr_reader :lesson
  
  attr_reader :questions_to_learn
  attr_reader :questions_to_repeat
  attr_reader :questions_passed
  
  attr_reader :current
  
  def initialize(lesson)
    @lesson = lesson
    
    to_randomize = @lesson.questions_to_learn.dup
    randomized = []
    
    randomized << to_randomize.slice!(rand(to_randomize.size)) until to_randomize.size.eql?(0)
    
    @questions_to_learn = randomized
    @questions_to_repeat = []
    @questions_passed = []
    
    if @questions_to_learn.size > 0
      @current = @questions_to_learn[0]
    else
      @current = nil
    end
    
    @just_passed = []
    @just_repeated = []
  end
  
  def correct
    deleted = self.questions_to_learn.delete self.current
    unless deleted
      deleted = self.questions_to_repeat.delete self.current
    end
     
    self.questions_passed << self.current
      
    if @repeated
       @just_repeated << self.current
    else
       @just_passed << self.current
    end
      
    @repeated = nil
    
    self.next_question
    deleted
  end
 
  def wrong
    if self.questions_to_learn.include? self.current
      @repeated = self.current
      self.questions_to_repeat << self.current
    elsif self.questions_to_repeat.include? self.current
      @repeated = nil
    end
 end

 def skip
    skipped = self.questions_to_learn.delete self.current
    if skipped
      self.questions_to_repeat << skipped
      @just_repeated << skipped
    end

    skipped = self.questions_to_repeat.delete self.current
    if skipped
      self.questions_to_repeat << skipped
    end

    @repeated = nil
    self.next_question
 end

 def get_changes
   changes = {:mark_repeat => @just_repeated.dup, :mark_correct => @just_passed.dup}
   
   @just_repeated = []
   @just_passed = []
   
   return changes
 end
 
 protected 
 
   def next_question
     if self.questions_to_learn.size > 0
       @current = self.questions_to_learn[0]
     elsif self.questions_to_repeat.size > 0 
       @current = self.questions_to_repeat[0]
     else
       @current = nil
     end
   end
 
end