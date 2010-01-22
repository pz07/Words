class LearningAttempt
  
  attr_reader :lesson
  
  attr_reader :questions_to_learn
  attr_reader :questions_to_repeat
  attr_reader :questions_passed
  
  attr_reader :current
  
  def initialize(lesson)
    @lesson = lesson
    
    to_randomize = @lesson.questions_to_learn_ids.dup
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
    deleted = nil
    
    i = self.questions_to_learn.index self.current
    if i
      deleted = self.questions_to_learn.delete_at i
    else
      i = self.questions_to_repeat.index self.current
      if i
        deleted = self.questions_to_repeat.delete_at i
      end
    end

    if @repeated
      @just_repeated << self.current
      deleted = nil
    else
       @just_passed << self.current
       self.questions_passed << self.current
    end
     
    @repeated = nil
    
    self.next_question
    
    return deleted
  end
 
  def wrong
    if self.questions_to_repeat.last != self.current
      self.questions_to_repeat << self.current
      @repeated = self.current
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
 
 def onlyRepetitions
   @just_passed = self.questions_to_learn
   @questions_to_learn = []
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