# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class MengbashaFetcher < Fetcher
    URL = "http://www.moonbasa.com/help/sitemap.aspx"

    def self.category_list
      c_arr = []
      html = open(URL).read
      html = html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
      doc = Nokogiri::HTML(html)
      doc.search("div.map_list ul:first/li/span/a").map do |elem|

        {
          :url => elem["href"],
          :name => elem.inner_text
        }
      end
    end
    
  end
end
