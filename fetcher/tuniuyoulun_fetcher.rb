#encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class TuniuyoulunFetcher < Fetcher
    URL = "http://www.tuniu.com"
    def self.category_list
	  [{
		:url => URI.escape("http://youlun.tuniu.com/main.php?city_input=&day_input=&do=tour_ajax_call&flag=change_youlun&gongsi_input=&hangxian_input=&month_input=&page=1"),
		:name => "豪华邮轮"
      }]
	end

  end
end
