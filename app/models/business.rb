# == Schema Information
# Schema version: 20101218032208
#
# Table name: businesses
#
#  id          :integer         primary key
#  name        :string(255)
#  description :text
#  created_at  :timestamp
#  updated_at  :timestamp
#

class Business < ActiveRecord::Base
	acts_as_taggable
	
  has_many :places, :dependent => :destroy
  has_many :rewards
  has_many :programs,:dependent => :destroy
  has_many :user_actions
  belongs_to :brand
  
  has_and_belongs_to_many :categories
  accepts_nested_attributes_for :places, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  
  has_many :reports, :as => :reportable

  attr_accessor :categories_list
  
  after_save :update_categories
	validates :tag_list, :presence=>true
  private
  def update_categories
    categories.delete_all
    selected_categories = categories_list.nil? ? [] : categories_list.keys.collect{|id| Category.find(id)}
    selected_categories.each {|category| self.categories << category}
  end
end
