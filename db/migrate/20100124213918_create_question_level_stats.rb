class CreateQuestionLevelStats < ActiveRecord::Migration
  def self.up
    create_table :question_level_stat do |t|
      t.integer :question_id, :null => false
      t.integer :level_id, :null => false
      t.timestamp :learning_begin, :null => false
      t.timestamp :learning_finished
      t.integer :correct_answers, :null => false, :default => 0
      t.integer :wrong_answers, :null => false, :default => 0

      t.timestamps
    end
    
    Question.find(:all).each do |q|
      q.lesson.learning_schema.levels.each do |l|
        q.question_level_stats << QuestionLevelStat.new(:question => q, :level => l, 
                    :learning_begin => Time.now, :correct_answers => 0, :wrong_answers => 0)   
      end
    end
  end

  def self.down
    drop_table :question_level_stat
  end
end
