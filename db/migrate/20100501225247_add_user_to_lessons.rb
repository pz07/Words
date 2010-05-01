class AddUserToLessons < ActiveRecord::Migration
  def self.up
    add_column :lesson, :user_id, :integer, :null => true
    
    users = User.all(:order => "id ASC")
    Lesson.find(:all).each do |l|
      l.user = users[0]
      l.save
    end
    
    change_column :lesson, :user_id, :integer, :null => false
  end

  def self.down
     remove_column :lesson, :user_id
  end
end
