class DeleteInvalidRecords < ActiveRecord::Migration
  def self.up
    Level.find(:all, :conditions => "learning_schema_id is null").each do |l|
      l.destroy!
    end
    Question.find(:all, :conditions => "lesson_id is null").each do |q|
      q.destroy!
    end
    Answer.find(:all, :conditions => "question_id is null").each do |a|
      a.destroy!
    end
  end

  def self.down
    #nic nie robie
  end
end
