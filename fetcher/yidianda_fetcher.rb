# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class YidiandaFetcher < Fetcher
    URL = "http://www.yidianda.com/index.aspx/"

    BaseUrl = "http://www.yidianda.com/"
    
    def self.category_list
      html = open(URL).read
      doc = Nokogiri::HTML(html)
      doc.css("div.shadow_border a").map do |e|
        {
          :url => BaseUrl + URI.escape(e["href"]),
          :name => e.inner_text
        }
      end
      
    end
    
  end
end
