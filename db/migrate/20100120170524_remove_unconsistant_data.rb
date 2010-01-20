class RemoveUnconsistantData < ActiveRecord::Migration
  def self.up
    Level.find(:all, :conditions => "learning_schema_id is null").each do |l|
      l.delete
    end
    Question.find(:all, :conditions => "lesson_id is null or level_id is null").each do |q|
      q.delete
    end
    Answer.find(:all, :conditions => "question_id is null").each do |a|
      a.delete
    end
  end

  def self.down
    #nic nie robie
  end
end
