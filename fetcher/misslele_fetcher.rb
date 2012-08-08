# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class MissleleFetcher < Fetcher
    URL = "http://www.misslele.com/sitemap.html"
    BaseURL = "http://www.misslele.com/"

    def self.category_list
      html = open(URL).read
      html = html.force_encoding("UTF-8").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
      doc = Nokogiri::HTML(html)
      doc.css("div.catecon a").map do |elem|
        {
          :name => elem.inner_text,
          :url => File.join(BaseURL, elem["href"])
        }
      end
    end

  end
end
