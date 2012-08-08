#encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class TuniumenpiaoFetcher < Fetcher
    URL = "http://menpiao.tuniu.com"

	def self.category_list

	  html = open(URL).read
	  html = html.force_encoding("UTF-8").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      doc = Nokogiri::HTML(html)
      doc.css("div.hot_ticket_w ul li a").map do |elem|

        {
          :url =>URL + elem[:href],
          :name => elem.inner_text.gsub("点","区")
        }
      end
	end
  end
end
