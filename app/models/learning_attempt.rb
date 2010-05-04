class LearningAttempt
  
  attr_reader :lesson
  
  attr_reader :repetition
  
  attr_reader :questions_to_learn
  
  attr_reader :current
  
  def initialize(user, repetition, lesson_id)
    if lesson_id then
      @lesson = Lesson.find(lesson_id);
    end
    
    @repetition = repetition
    
    to_randomize = nil
    if @repetition then
       if @lesson then
         to_randomize = Repetition.find_all_by_lesson_id_and_user_id(@lesson, user).collect do |r|
              r.question_id
         end
       else
         to_randomize = Repetition.find_all_by_user_id(user).collect do |r|
           r.question_id
         end
       end
    else  
       if @lesson then
         to_randomize = @lesson.questions_to_learn_ids.dup 
       else
         to_randomize = Question.find(:all, :include => [:lesson], 
                                  :conditions => ["next_attempt_date < ? and lesson.user_id = ? and lesson.active = ?", Time.now.utc.tomorrow.at_beginning_of_day, user, true]).collect do |q|
            q.id
         end
       end
    end
    
    to_randomize.uniq!
    
    randomized = []
    randomized << to_randomize.slice!(rand(to_randomize.size)) until to_randomize.size.eql?(0)
    
    @questions_to_learn = randomized
    
    if @questions_to_learn.size > 0
      @current = @questions_to_learn[0]
    else
      @current = nil
    end
    
    @just_passed = []
    @just_repeated = []
  end
  
  def mark note
    deleted = nil
    
    i = self.questions_to_learn.index self.current
    if i
      deleted = self.questions_to_learn.delete_at i
    end
    
    if note >= 4 then
      @just_passed << self.current
    else
      @just_repeated << self.current
    end
    
    if @repetition and note < 4 then
      self.questions_to_learn << deleted
    end

    self.next_question
    
    return deleted
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
     else
       @current = nil
     end
   end
 
end