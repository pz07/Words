class Answer < ActiveRecord::Base
  
  #zależności
  belongs_to :question
  
  #walidacja
  validates_presence_of :text, :question, :priority
  validates_numericality_of :priority, :only_integer => true
  
end
