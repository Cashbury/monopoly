class Role < ActiveRecord::Base
  attr_accessible :name

  AS = {
    :admin      =>"admin",
    :operator   =>"operator",
    :principal  =>"principal",
    :accountant =>"accountant",
    :manager    =>"manager",
    :branch_manager =>"branch_manager",
    :cashier    => "cashier",
    :consumer   => "consumer"
  }
  
  DISPLAYED_AS={
    :admin      =>"admin",
    :operator   =>"operator",
    :principal  =>"principal at business",
    :accountant =>"accountant at business",
    :manager    =>"manager at business",
    :branch_manager =>"branch manager at business",
    :cashier    => "cashier at business",
    :consumer   => "consumer"
  }

  #has_and_belongs_to_many :users
  has_many :employees, :dependent=>:destroy
  has_many :users, :through=>:employees
  
  def displayed_role
    DISPLAYED_AS[self.name.to_sym]
  end
  
  def require_business?
    [:principal,:accountant,:manager,:branch_manager,:cashier].include?(self.name.to_sym) 
  end
end
