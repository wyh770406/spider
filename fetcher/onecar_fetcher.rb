# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class OnecarFetcher < Fetcher
    URL = "http://www.1car.com.cn/catalog.asp"
	BASE_URL = "http://www.1car.com.cn"

    def self.category_list
      html = open(URL).read
	  html = html.force_encoding('GB2312').encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      doc = Nokogiri::HTML(html)
      doc.css("table.tablewhite td a.tablewhite[href]").map do |e|
        {
          :url => File.join(BASE_URL, e[:href]),
          :name => e.inner_text.strip
        }
      end
      
    end
    
  end
end
