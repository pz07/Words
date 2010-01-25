class QuestionLevelStat < ActiveRecord::Base

  #zależności
  belongs_to :question
  belongs_to :level
  
  #walidacja
  validates_presence_of :question, :level, :learning_begin, :correct_answers, :wrong_answers
end
