class Role < ActiveRecord::Base
  attr_accessible :name

  AS = {
    :super_admin=>"super_admin",
    :admin      =>"admin",
    :mobi       => "mobi",
    :operator   =>"operator",
    :principal  =>"principal",
    :accountant =>"accountant at business",
    :manager    =>"manager at business",
    :branch_manager =>"branch manager at business",
    :cashier    => "cashier",
    :consumer   => "consumer"
  }

  #has_and_belongs_to_many :users
  has_many :employees, :dependent=>:destroy
  has_many :users, :through=>:employees
  
  def displayed_role
    AS[self.name.to_sym]
  end
  
  def require_business?
    [:principal,:accountant,:manager,:branch_manager,:cashier].include?(self.name.to_sym)
    
  end
end
