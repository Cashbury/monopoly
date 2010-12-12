class Business < ActiveRecord::Base
  has_many :places, :dependent => :destroy
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :places, :allow_destroy => true
  
  attr_accessible :name, :description, :categories_list
  attr_accessor :categories_list
  
  after_save :update_categories
  
  private
  def update_categories
    categories.delete_all
    selected_categories = categories_list.nil? ? [] : categories_list.keys.collect{|id| Category.find(id)}
    selected_categories.each {|category| self.categories << category}
  end
end
