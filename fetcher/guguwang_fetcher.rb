# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class GuguwangFetcher < Fetcher
    URL = "http://www.guguwang.com"

    def self.category_list
      html = open(URL).read
	  html = html.force_encoding('UTF-8').encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      doc = Nokogiri::HTML(html)
      doc.css("table.c-cat-depth-2 td a").map do |e|
        {
          :url => e[:href],
          :name => e.inner_text.strip
        }
      end
      
    end
    
  end
end
