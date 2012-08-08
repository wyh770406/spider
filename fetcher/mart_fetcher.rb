# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class MartFetcher < Fetcher
    URL = "http://www.360mart.com/"

    def self.category_list
      html = open(URL).read
      doc = Nokogiri::HTML(html)
      doc.css("dd.skind a[@href]").map do |e|
        {
          :url => URI.escape(e["href"]),
          :name => e.inner_text
        }
      end
      
    end
    
  end
end
