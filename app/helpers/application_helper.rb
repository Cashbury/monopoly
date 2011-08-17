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
	
	def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')")
  end


  def mark_required(object, attribute)
    "*" if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
  end

  def live?(object)
    if object.is_live?
      "<b> Live </b>"
    else
      "<b> not live yet</b>"
    end
  end

  def fb_feed_status_for(user)
    if user.is_fb_enabled?
      "<b style='color:green'>active</b>"
    else
      "<b style='color:red'>Inactive</b>"
    end
  end

  def toggle_fb_link(user)
   if user.is_fb_enabled?
      link_to "Deactivate FB feed" , "/v1/users/#{user.id}/off.html" , :id=>"deactivate"
    else
      link_to "Active FB feed", "/v1/users/#{user.id}/on.html", :id=>"activate"
    end
  end

  def css3button(text,options={:tag=>:span, :class=>nil})
    content_tag(options[:tag], :class=>options ) + text
  end

  def status_icon(status)
    image_tag  status ?  "check_small.png" : "cross_small.png"
  end

  def currency_icon
    raw current_user.try(:country).try(:currency_code) || "&#36;"
  end
  
end


