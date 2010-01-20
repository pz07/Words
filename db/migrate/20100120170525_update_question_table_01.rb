class UpdateQuestionTable01 < ActiveRecord::Migration
  def self.up
    add_column :question, :next_attempt_date, :datetime, :null => false, :default => Time.now
    rename_column :question, :last_level_update, :last_attempt_date
    
    Question.reset_column_information
    
    Question.find(:all).each do |q|
      q.next_attempt_date = q.compute_next_attempt_date
      q.save!
    end
  end

  def self.down
    #nic nie robie
  end
end
