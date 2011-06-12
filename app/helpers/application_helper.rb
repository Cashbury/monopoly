module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end
	def mark_required(object, attribute)
  	"*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
	end
end