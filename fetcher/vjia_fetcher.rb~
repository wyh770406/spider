# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class VjiaFetcher < Fetcher
    URL = "http://www.vjia.com/"
    BaseURL = "http://www.vjia.com"

		def self.category_list
		  c_arr = []
		  html = open(URL).read
		  html = html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
		  doc = Nokogiri::HTML(html)
		  #doc.search("div.headMenu ul.mainNav li a")
                  ["http://www.vjia.com/List-2850----0-0-6-1--0-0-0---.html",
                    "http://channel.vjia.com/man",
                    "http://channel.vjia.com/women",
                    "http://channel.vjia.com/bag",
                    "http://channel.vjia.com/sports",
                    "http://www.vjia.com/List-1292.html",
                    "http://www.vjia.com/List-1220.html",
                      "http://www.vjia.com/channel2010/meizhuang.html",
                       "http://www.vjia.com/star/",
                          "http://www.vjia.com/List-3303----0-0-6-1--0-0-0---.html",
                       "http://www.vjia.com/List-2732----0-0-6-1--0-0-0---.html"].each do |big_elem|

  	      # 第二层
		    second_html = open(big_elem).read
		    # 美妆进去的首页没有小分类,所以要抓个url替换美妆的首页
  	      if big_elem.include?("meizhuang")
		      second_html = second_html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
			  second_doc = Nokogiri::HTML(second_html)
			  replace_elem = second_doc.search("div.mz-nav ul li a[@target]")[1]
			  second_html = open(replace_elem["href"]).read
			end
 	      if big_elem.include?("bag")
			  second_html = open("http://www.vjia.com/List-3306----0-0-6-1--0-0-0---.html").read
			end
 	      if big_elem.include?("man")
			  second_html = open("http://www.vjia.com/List-1369.html").read
			end
 	      if big_elem.include?("women")
			  second_html = open("http://www.vjia.com/List-1548.html").read
			end
 	      if big_elem.include?("sports")
			  second_html = open("http://www.vjia.com/List-2468.html").read
			end
 	      if big_elem.include?("star")
		      #second_html = second_html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
			  #second_doc = Nokogiri::HTML(second_html)
			  #replace_elem = second_doc.search("div.mz-nav ul li a[@target]")[1]
			  second_html = open("http://www.vjia.com/List-2921.html").read
			end
		    second_html = second_html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
			second_doc = Nokogiri::HTML(second_html)
			# 第一种情况
			c_arr.concat(
			  second_doc.css(".productKinds dl dd a").map do |elem|
				# 有个错误的特殊的链接
				elem["href"] = elem["href"].sub("hthttp", "http") if elem["href"].present? && elem["href"].include?("hthttp")
				# 还有#的链接
				next if elem["href"].to_s == "#"
				{
				  :url => URI.escape(elem["href"].to_s),
				  :name => elem.inner_text.strip
				}
			  end.compact
			)
  	        # 第二种情况
			second_doc.search("ul#nav li h5 a[@href]").each do |elem|
			  ele = elem.parent.next_element
			  if ele.nil?
			    c_arr.concat(
				[
				  :url => URI.escape(File.join(BaseURL, elem["href"]).to_s),
				  :name => elem.inner_text.strip.split("(")[0]
			    ]
			    ) 
				else
				  c_arr.concat(
				    ele.css("li a[@href]").map do |e|
				    next if e["href"].to_s == "#"
					{
					  :url => URI.escape(File.join(BaseURL, e["href"]).to_s),
					  :name => e.inner_text.strip.split("(")[0]
					}
				  end.compact
				  )
				end

			  end

		  end
		  
		  c_arr.flatten
		  return c_arr
		end

  end
end

