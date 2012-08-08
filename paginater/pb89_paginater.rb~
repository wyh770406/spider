# encoding: utf-8
require "nokogiri"
module Spider
  class Pb89Paginater < Paginater
    attr_reader :doc, :url
   
	URL = "http://www.pb89.com"
    def initialize(item)
	  @url = item.url
	  @doc = Nokogiri::HTML(item.html)
	end 
  
    def pagination_list
      max_page = doc.css("div.p_page2 a").present? ? doc.css("div.p_page2 a")[-2].text.to_i : 1
	  puts max_page
	  if max_page == 1
		return [url]
	  end
	  (1..max_page).map do |i|
		category_id = url.split("category/")[1][/\d+/]
        URL + "/category/#{category_id}/#{i}/goods_id.html"
	  end
	end


  end

end



 
