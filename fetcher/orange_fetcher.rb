# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class OrangeFetcher < Fetcher
    URL = "http://www.orange3c.com/allsorts.html"

    def self.category_list
      html = open(URL).read
      doc = Nokogiri::HTML(html)
      doc.css("dd a").map do |e|
        {
          :url => URI.escape(e["href"]).gsub(".html","-grid.html"),
          :name => e.inner_text
        }
      end

    end

  end
end
