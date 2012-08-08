#encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class TuniutourFetcher < Fetcher
    URL = "http://www.tuniu.com"
    def self.category_list
	  html = open(URL).read
	  c_arr = []
	  html = html.force_encoding('utf-8').encode("UTF-8", :invalid => :replace, :undef => :replace, :repalce => "?")
	  doc = Nokogiri::HTML(html)
	  doc.search("div#site_city a").each do |city|
        # 第二层
		second_html = open(city["href"]).read
		second_html = second_html.force_encoding('utf-8').encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
		second_doc = Nokogiri::HTML(second_html)
	    # 第三层 游轮不抓
		c_arr.concat(
		  second_doc.css("ul#nav_t li a").map do |big_category|
		    next if big_category["href"].to_s.include?("youlun") || big_category["href"].to_s.include?("hotel") || big_category["href"].to_s.include?("menpiao")
		    {
				:url => URI.escape(big_category["href"].to_s),
				:name => big_category.inner_text.strip	
			}
		  end.compact 
		)
	  end
	  # 去掉主页
	  c_arr.flatten
	  c_arr.delete_if{|category| category[:url] == "http://www.tuniu.com/"}
	end 
  end
end
