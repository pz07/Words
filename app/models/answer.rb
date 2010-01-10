class Answer < ActiveRecord::Base
  
  #zależności
  belongs_to :question
  
  #walidacja
  validates_presence_of :text
  
end
