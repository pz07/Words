class LearningAttempt
  
  attr_reader :lesson
  
  attr_reader :questionsToLearn
  attr_reader :questionsToRepeat
  attr_reader :questionsPassed
  
  def initialize(lesson)
    @lesson = lesson
    
    to_randomize = @lesson.questionsToLearn.dup
    randomized = []
    
    randomized << to_randomize.slice!(rand(to_randomize.size)) until to_randomize.size.eql?(0)
    
    @questionsToLearn = randomized
    @questionsToRepeat = []
    @questionsPassed = []
  end
  
  def correct(questionId)
     deleted = self.questionsToLearn.delete questionId.to_i
     unless deleted
       deleted = self.questionsToRepeat.delete questionId.to_i
     end
     
     if deleted
       self.questionsPassed << deleted
       deleted
     end
 end
 
 def wrong(questionId)
     deleted = self.questionsToLearn.delete questionId.to_i
     if deleted
       self.questionsToRepeat << deleted
       deleted
     end
  end
end