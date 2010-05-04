class Lesson < ActiveRecord::Base

  #zależności
  has_many :questions, :dependent => :destroy
  belongs_to :user
  
  #walidacja
  validates_presence_of :name, :user
  validates_uniqueness_of :name
  
  def questions_to_learn
    Question.find(:all, :conditions => ['next_attempt_date < ? and lesson_id = ?', Time.now.utc.tomorrow.at_beginning_of_day, self.id ])
  end
  
  def questions_to_learn_ids
    self.questions_to_learn.collect do |q|
      q.id
    end
  end
    
end
