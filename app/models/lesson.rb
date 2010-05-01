class Lesson < ActiveRecord::Base

  #zależności
  has_many :questions, :dependent => :destroy
  belongs_to :user
  belongs_to :learning_schema
  
  #walidacja
  validates_presence_of :name, :learning_schema, :user
  validates_uniqueness_of :name
  
  def questions_to_learn
    Question.find(:all, :conditions => ['next_attempt_date <= ? and lesson_id = ?', Time.now.utc, self.id ])
  end
  
  def questions_to_learn_ids
    self.questions_to_learn.collect do |q|
      q.id
    end
  end
  
  #def questions_to_learn_ids
  #  to_learn = []
  #  
  #  questions.each do |q|
  #    if q.active
  #      if q.level.level == learning_schema.start_level.level
  #        to_learn << q.id
  #      else
  #        if 2.hours.ago(q.last_level_update.advance(:days => q.level.day_interval)) <= Time.zone.now
  #          to_learn << q.id
  #        end
  #      end  
  #    end
  #  end
  #  
  #  to_learn
    #question_ids
  #end
  
end
