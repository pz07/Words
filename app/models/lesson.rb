class Lesson < ActiveRecord::Base

  #zależności
  has_many :questions, :dependent => :destroy
  belongs_to :learning_schema
  
  #walidacja
  validates_presence_of :name, :learning_schema
  validates_uniqueness_of :name
  
  def questions_to_learn
    to_learn = []
    
    questions.each do |q|
      if q.active
        if q.level.level == learning_schema.start_level.level
          to_learn << q.id
        else
          if 2.hours.ago(q.last_level_update.advance(:days => q.level.day_interval)) <= Time.zone.now
            to_learn << q.id
          end
        end  
      end
    end
    
    to_learn
    #question_ids
  end
  
end
