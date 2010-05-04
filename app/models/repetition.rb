class Repetition < ActiveRecord::Base

  #zależności
  belongs_to :user
  belongs_to :question
  

end
