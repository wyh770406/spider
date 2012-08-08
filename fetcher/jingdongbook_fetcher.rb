# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class JingdongbookFetcher < Fetcher
    URL = "http://www.360buy.com/book/booksort.aspx"

    def self.category_list
      html = open(URL).read
      html = html.force_encoding("GB18030").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
      doc = Nokogiri::HTML(html)
      doc.css("div#booksort dd em a").map do |elem|
        {
          :name => elem.inner_text,
          :url => elem[:href]
        }
      end
    end
  end
end
