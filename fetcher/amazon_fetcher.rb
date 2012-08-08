# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class	AmazonFetcher < Fetcher
  	
		URL = "http://www.amazon.cn"
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

		def self.get_big_cate
			doc = AmazonFetcher.open_and_html(URL)
			arr = []
			doc.css(".navSaChildItem a").each_with_index do |elem, index|
				if index >= 3
					arr << { :url => URL + elem["href"], :name => elem.text }
				end
			end
			return arr
			#AmazonFetcher.analyze(URL, ".navSaChildItem a")
		end

		def self.get_low_cate(url)
			css_str = '#navCatSubnav .navSubItem a'
			exclude_titles = ["高级搜索", "排行榜", "新品上架", "特价", "所有产品", "品牌"]
			html_tags = []
			AmazonFetcher.open_and_html(url).css(css_str).each do |item|
				#if item.inner_text.strip == "品牌"
				#	html_tags += self.analyze(URL+ item[:href], ".refList a")
				#else
					unless exclude_titles.include?(item.inner_text.strip)
					#	html_tags << self.get_child_cate(item[:url])
						html_tags << {:name => item.inner_text, :url => URL + item[:href]}
					end
				#end
			end
			return html_tags
		end

=begin
		def slef.get_child_cate(url)
			exclude_words = []
			arr = self.analyze(url, ".left_nav").to_a
			results = []
			arr.each do |item| unless exclude_words.include? item.children.first.text.strip
					results += item.css("li a")
				end
			end
			results
		end
=end

		def self.category_list
			arr = []
			#arr << AmazonFetcher.analyze(BOOK_URL, ".left_nav li a") # for book
			AmazonFetcher.get_big_cate.each do |item|
				arr += self.get_low_cate(item[:url])
			end
			return arr
		end
		

=begin
		#获取含有more链接底层的category
		def self.get_low_cate_has_more(url, seeMore_type, nth_child='')
			doc = AmazonFetcher.open_and_html(url)
			css_str = (nth_child != '' ? ".left_nav:nth-child(#{nth_child})" : ".left_nav")
			arr1 = doc.css(css_str + " li a")
			if seeMore_type == 1
				arr2 = doc.css(css_str + " .seeMore a")
				return (arr1 + arr2).map do |elem|
					{
						:url => URL + elem["href"],
						:name => elem.text
					}
				end
			elsif seeMore_type == 2
				arr2 = doc.css(css_str + " .seeMore a").map do |elem|
					AmazonFetcher.analyze(URL+elem[:href], ".refList a")
				end.flatten
				return arr1.map do |elem|
				{
					:url => URL + elem["href"],
					:name => elem.text
				}
				end + arr2
			end
		end

		def self.category_list
			arr = []
			arr << AmazonFetcher.analyze(BOOK_URL, ".left_nav li a") # for book
			AmazonFetcher.get_big_cate.each do |item|
					arr << AmazonFetcher.analyze(item[:url], ".left_nav:nth-child(1) li a") if ["教育音像", "小家电", "电脑产品", "游戏"].include?(item[:name])
					#puts item[:name]
					#puts item[:url]
					arr << AmazonFetcher.analyze(item[:url], ".left_nav:nth-child(3) li a") if ["影视", "音乐", "手机、通讯", "软件", "美容化妆", "露营及户外"].include?(item[:name])
					arr << AmazonFetcher.get_low_cate_has_more(item[:url], 2, 3) if ["手机、通讯", "运动服饰", "体育用品"].include?(item[:name])
					arr << AmazonFetcher.get_low_cate_has_more(item[:url], 1, 6) if ["摄影、摄像"].include?(item[:name])
					arr << AmazonFetcher.get_low_cate_has_more(item[:url], 1, 3) if ["数码影音", "电视 、音响", "电视 、音响", "大家电", "DIY电脑硬件", "办公用品", "家居", "家居装修", "厨具", "电视 、音响", "食品", "个护健康", "玩具", "母婴用品", "健身训练", "所有产品", "皮具箱包", "服装服饰", "鞋靴", "钟表", "珠宝首饰", "所有汽车用品"].include?(item[:name])
					arr << AmazonFetcher.get_low_cate_has_more(item[:url], 1) if ["GPS、车载电器", "汽车养护维修", "汽车装饰", "自驾游用品"].include?(item[:name])
			end
			arr.flatten
		end
=end

  end
end
