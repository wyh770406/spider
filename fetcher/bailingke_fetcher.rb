# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class BailingkeFetcher < Fetcher
    URL = "http://www.bailingke.com"
	def self.category_list
	  html = open(URL).read
	  html = html.force_encoding("GBK").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      doc = Nokogiri::HTML(html)
      doc.css("div#category_tree dd a").map do |elem|
		{
		  :name => elem.inner_text,
		  :url => File.join(URL, elem["href"])
	    }
	  end
    end
  end
end
