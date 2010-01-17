class LearningAttempt
  
  attr_reader :lesson
  
  attr_reader :questions_to_learn
  attr_reader :questions_to_repeat
  attr_reader :questions_passed
  
  def initialize(lesson)
    @lesson = lesson
    
    to_randomize = @lesson.questions_to_learn.dup
    randomized = []
    
    randomized << to_randomize.slice!(rand(to_randomize.size)) until to_randomize.size.eql?(0)
    
    @questions_to_learn = randomized
    @questions_to_repeat = []
    @questions_passed = []
  end
  
  def correct(questionId)
     deleted = self.questions_to_learn.delete questionId.to_i
     unless deleted
       deleted = self.questions_to_repeat.delete questionId.to_i
     end
     
     if deleted
       self.questions_passed << deleted
       deleted
     end
 end
 
 def wrong(questionId)
     deleted = self.questions_to_learn.delete questionId.to_i
     if deleted
       self.questions_to_repeat << deleted
       deleted
     end
  end
end