# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class VanclFetcher < Fetcher
    URL = "http://www.vancl.com/map/default.aspx"

    def self.category_list
      html = open(URL).read
      doc = Nokogiri::HTML(html)
      doc.css("td.bgC02 a").map do |e|
        {
          :url => URI.escape(e["href"]).gsub("search.aspx?pcid=","").concat(".html"),
          :name => e.inner_text
        }
      end.concat(
        doc.css("td.bgC04 a").map do |e|
          {
            :url => URI.escape(e["href"]).gsub("search.aspx?pcid=","").concat(".html"),
            :name => e.inner_text
          }
        end
      )
      
    end
    
  end
end
