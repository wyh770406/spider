# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class	AmazonbookFetcher < Fetcher
  	
		BOOK_URL = "http://www.amazon.cn/gp/feature.html/ref=sv_b_1?ie=UTF8&docId=42108"

		def self.open_and_html(url)
			#puts url
			html = open(url).read
			unless url.match(/^http/)
				url = URL + url
			end
      html.encode!("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
			Nokogiri::HTML(html)
		end

		def self.analyze(url, css_str)
			doc = AmazonFetcher.open_and_html(url)
			doc.css(css_str).map do |elem|
			{
				:url => URL + elem["href"],
				:name => elem.text
			}
			end
		end

		def self.category_list
			AmazonFetcher.analyze(BOOK_URL, ".left_nav li a")
		end
  end
end
