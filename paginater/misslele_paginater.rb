# encoding: utf-8
require 'nokogiri'

module Spider
  class MisslelePaginater < Paginater
    attr_reader :doc, :url
    BaseURL = "http://www.misslele.com/"

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page_doc = doc.css("div.page span a")
      max_page = max_page_doc.size - 1
      if max_page > 0
		    url_string = doc.css("div.page span a")[max_page]["href"]
      else
        max_page = 1
        url_string = url[24..35] + "0-3-0-12-0-0-0-5-1-1-1.html"
      end
	   return (1..max_page).map do |i|
				url_string[-8] = "#{i}"
	      url_string.inspect
        puts BaseURL + url_string 
	       BaseURL + url_string 
	    end
    end 
  end
end
