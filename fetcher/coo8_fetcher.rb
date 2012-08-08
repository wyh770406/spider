# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class Coo8Fetcher < Fetcher
    URL = "http://www.coo8.com/allcatalog/"

    def self.category_list
      c_arr = []
      html = open(URL).read
      html = html.force_encoding("GBK").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
      doc = Nokogiri::HTML(html)
      doc.search("div.cateItems div.hd h2").each do |elem|
        ele = elem.parent.next_element
        c_arr.concat(
          ele.css("dd a[@href]").map do |e|
            {
              :url => e["href"],
              :name => e.inner_text
            }
          end
        )
      end
      
      return c_arr
    end
    
  end
end
