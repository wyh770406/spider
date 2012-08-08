# encoding: utf-8
require 'nokogiri'
module Spider
  class OkbuyPaginater < Paginater
    attr_reader :doc, :url

	def initialize(item)
	  @url = item.url
	  @doc = Nokogiri::HTML(item.html)
	end
    
	def pagination_list
          
	  #length = doc.css("div.goodsList li").length
      max_page = doc.css("div.addons span").text.split("/").last.to_i#(length.to_f/100).ceil
      if max_page == 1
	    [url]
      else
		(1..max_page).map do |i|
		  url + "&per_page=#{100 * (i - 1)}"
		end
	  end
	  
	end
  end

end
