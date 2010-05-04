class Iteration < ActiveRecord::Base

  #zależności
  belongs_to :question

  #walidacja
  validates_presence_of :question, :learning_begin, :answers_0, :answers_1, :answers_2, :answers_3, :answers_4, :answers_5

end
