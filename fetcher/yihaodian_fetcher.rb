# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class YihaodianFetcher < Fetcher
    URL = "http://www.yihaodian.com/product/listAll.do"

    def self.category_list
      html = open(URL).read
      doc = Nokogiri::HTML(html)
      doc.css("dd.detail a[@href]").map do |e|
        {
          :url => URI.escape(e["href"]),
          :name => e.inner_text
        }
      end
      
    end
    
  end
end
