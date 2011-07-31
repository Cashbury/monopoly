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
end


