class User < ActiveRecord::Base
    set_table_name "users"
  
    acts_as_authentic
    #acts_as_authentic do |c|
    #  c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
    #end # block optional
end
