class AppUser < ActiveRecord::Base
    set_table_name "app_user"
  
    acts_as_authentic
    #acts_as_authentic do |c|
    #  c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
    #end # block optional
end
