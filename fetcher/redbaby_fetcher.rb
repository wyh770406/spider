# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class	RedbabyFetcher < Fetcher
  	
		URL = "http://www.redbaby.com.cn/category"
		BASEURL = "http://www.redbaby.com.cn/"

		def self.category_list
			c_arr = []
			html = open(URL).read 
      html = html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
			doc = Nokogiri::HTML(html)
			doc.css('.allbrandContentBoxLeft a').map do |elem|		# => 此处有两种情况, .allbrandContent span a
				{
					:name => elem.inner_text,
					:url =>  File.join(BASEURL, elem["href"])
				}
			end
  	end
  end
end
