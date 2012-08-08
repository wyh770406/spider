# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class	DangdangbookFetcher < Fetcher
  	
		URL = "http://list.dangdang.com/book/01.htm?ref=book-02-B"
		BASEURL = "http://list.dangdang.com/book"

		def self.common_category_list(url)
			html = open(url).read
      html.encode!("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
			doc = Nokogiri::HTML(html)
			doc.css("a[name='linkCategory']").map do |elem|
				{
					:url => File.join(BASEURL, elem["href"]),
					:name => elem[:title]
				}
			end
		end

		def self.category_list
			top_categories = DangdangbookFetcher.common_category_list(URL)
			top_categories.map do |elem|
				DangdangbookFetcher.common_category_list(elem[:url])
			end.flatten
  	end

  end
end
