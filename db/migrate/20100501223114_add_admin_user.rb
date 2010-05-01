class AddAdminUser < ActiveRecord::Migration
  def self.up
    User.delete_all
    
    User.new(:email => "pawel.zieba83@gmail.com", :password => "admin", :password_confirmation => "admin", :admin => "true").save(false)
  end

  def self.down
    User.delete_all
  end
end
