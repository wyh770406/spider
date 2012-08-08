#encoding: utf-8
require 'nokogiri'
module Spider
  class TuniuPaginater < Paginater
    attr_reader :doc, :url

	def initialize(item)
	  @url = item.url
	  @doc = Nokogiri::HTML(item.html)
	end

	def pagination_list
          max_page = doc.css("div#list-navR span")[1].text.split("/").last
          return (1..max_page).map{|i| "#{url}/0_1_0_#{i}/"}

	  search_keys = ["div.category_list_inner ul li a", "div.l_menu.clear.mb10 ul:not(.other_link.star) li a", "div.category_list_inner dl dd a"]
	  urls = []
	  max_page = 0
	  flag = false
	  if url.to_s.include?("youlun")
	    max_page = (doc.search("a").last.next.text.split("：")[1].to_f / 10).ceil
	    flag = true
		urls = (1..max_page).map do |i|
		  url.split("page=")[0] + "page=" + i.to_s
		end
	  elsif url.to_s.include?("hotel")
	    max_page = (doc.search("div.hotel_con_opR a")[0].next.text.split(" ")[1].split("家酒店")[0].to_f / 10).ceil
		flag = true
		urls = (1..max_page).map do |i|
		  url.split("page=1")[0] + "page=" + i.to_s + url.split("page=1")[1]
		end	
	  end
	  search_keys.each do |key|
	    if doc.search(key).present?
		  flag = true
		  urls = doc.css(key).map do |paginator|
		    next if (paginator.parent.present? && paginator.parent.parent.present? && paginator.parent.parent.previous_element.present? && paginator.parent.parent.previous_element.text.to_s == "签证办理") || paginator["href"].to_s.include?("youlun")
		    paginator["href"].to_s
		  end.compact
		end	
	  end
	  if flag
		return urls
	  else
		return [url]
	  end
	end
  end
end
