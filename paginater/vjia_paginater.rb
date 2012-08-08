# encoding: utf-8
require 'nokogiri'
module Spider
  class VjiaPaginater < Paginater
    attr_reader :doc, :url

	def initialize(item)
	  @url = item.url
	  @doc = Nokogiri::HTML(item.html)
	end

	def pagination_list
	  # 分为一般情况和箱包情况
	  max_page = doc.css("h4 div.total strong").present? ? (doc.css("h4 div.total strong").inner_text.to_f/60).ceil : (doc.css("div.body1 div.crumb div.c2 span.b").inner_text.to_f/60).ceil
	  	# 三种情况
	  	# 箱包 www.vjia.com/search/index.mvc?k=
	 if url.include?("search")
		(1..max_page).map do |i|
		  url + "&pi=#{i}"
	 	end 
	  else
		# http://www.vjia.com/List-2502----0-0-6-1--0-0-0---.html
	  	# http://www.vjia.com/List-1292.html
		special = "----0-0-6-"
		base_url = url.include?(special) ? url.split(special)[0] : url.split(".html")[0]
	    url = (1..max_page).map do |i|
		  last_url = i.to_s + "--0-0-0---.html"
		  first_url = base_url +special
		  first_url + last_url 
		end
		return url
      end
	end
  end
end
