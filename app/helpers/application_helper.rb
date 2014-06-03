module ApplicationHelper
	def my_render(text)
		coderay_text = coderay(text).html_safe
		coderay_text.gsub! "\n", "<br/>"
		coderay_text.html_safe
	end

	def coderay(text)
	  text.gsub(/\<code\>(.+?)\<\/code\>/m) do
	    content_tag("notextile", CodeRay.scan($1, "ruby").div(:css => :class).html_safe)
	  end
	end
end
