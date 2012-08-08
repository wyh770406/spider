# encoding: utf-8
require 'open-uri'
require 'nokogiri'


module Spider
  class OkbuyFetcher < Fetcher
    URL = "http://www.okbuy.com"

	def self.category_list
	  html = open(URL).read
	  doc = Nokogiri::HTML(html)
	  doc.css(".cell div.content a").map do |element|
	    {
	      :url => element["href"].gsub("list.php?","product/search?&"),
		  :name => element.inner_text
		}
	  end
	end
  end
end
