#encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class TuniuFetcher < Fetcher
    URL = "http://www.tuniu.com"
    def self.category_list
	  c_arr = []
	  html = open(URL).read
	  html = html.force_encoding('utf-8').encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
	  doc = Nokogiri::HTML(html)
      # 游轮和酒店是不用抓城市的
	  doc.search("ul#nav_t li a").each do |category|
	    next unless category["href"].to_s.include?("youlun") || category["href"].to_s.include?("hotel") || category["href"].to_s.include?("menpiao")
		if category["href"].to_s.include?("hotel")
		  second_menpiao_html = open(category["href"]).read
		  second_menpiao_html = second_menpiao_html.force_encoding('utf-8').encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
		  second_menpiao_doc = Nokogiri::HTML(second_menpiao_html)
		  c_arr.concat(
			second_menpiao_doc.css("div.jd_hot_keyword a").map do |small_category|
		      now_date = Time.now.to_date.strftime("%Y-%m-%d")
		      next_date = Time.now.to_date.next_day.strftime("%Y-%m-%d")
			  {
				:url => URI.escape("http://hotel.tuniu.com/main.php?do=hotel_new_search_ajax&begin_date=" + now_date + "&business_park=&business_park_id=0&city=" + small_category.inner_text + "&end_date=" + next_date + "&hotel_name=&orderby=0&page=1&price=1&room_num=1&star=0"),
				:name => small_category.inner_text.strip
			  }
			end.compact
		  )
	    elsif category["href"].to_s.include?("youlun")	  
		  c_arr << {
		    :url => URI.escape("http://youlun.tuniu.com/main.php?city_input=&day_input=&do=tour_ajax_call&flag=change_youlun&gongsi_input=&hangxian_input=&month_input=&page=1"),
		    :name => category.inner_text.strip
		  }
		else
		  c_arr << {
		    :url => URI.escape(category["href"].to_s),
			:name => category.inner_text.strip
		  }
		end
	  end
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
