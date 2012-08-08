# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class HcyxbookFetcher < Fetcher
    URL = "http://www.hcyxbook.com"
	def self.category_list
	  html = open(URL).read
	  html = html.force_encoding("GB18030").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      doc = Nokogiri::HTML(html)
	  categories = []
      doc.css("div#lefttable h4 a").each do |big_category|
	    if big_category.parent.next_element.css("li").blank?
		  categories << {:name => big_category.inner_html, :url => File.join(URL, big_category["href"])}
		end
	  end  
	      categories << doc.css("div#lefttable li a").map do |elem|
		    {
			  :name => elem.inner_text,
			  :url => File.join(URL, elem["href"])
			}
	  end	
	  categories.flatten
	end

  end
end

