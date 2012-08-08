#encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class TuniuhotelFetcher < Fetcher
    URL = "http://www.tuniu.com"
    ACATEL=[
        {
	  		:name => "北京酒店",
	  		:url => "http://hotel.tuniu.com/city_200"
        },
        {
	  		:name => "上海酒店",
	  		:url => "http://hotel.tuniu.com/city_2500"
        },
        {
	  		:name => "南京酒店",
	  		:url => "http://hotel.tuniu.com/city_1602"
        },
        {
	  		:name => "杭州酒店",
	  		:url => "http://hotel.tuniu.com/city_3402"
        },
        {
	  		:name => "苏州酒店",
	  		:url => "http://hotel.tuniu.com/city_1615"
        },
        {
	  		:name => "天津酒店",
	  		:url => "http://hotel.tuniu.com/city_3000"
        },
        {
	  		:name => "深圳酒店",
	  		:url => "http://hotel.tuniu.com/city_619"
        },
        {
	  		:name => "成都酒店",
	  		:url => "http://hotel.tuniu.com/city_2802"
        },
        {
	  		:name => "武汉酒店",
	  		:url => "http://hotel.tuniu.com/city_1402"
        },
        {
	  		:name => "青岛酒店",
	  		:url => "http://hotel.tuniu.com/city_2413"
        },
        {
	  		:name => "沈阳酒店",
	  		:url => "http://hotel.tuniu.com/city_1902"
        },
        {
	  		:name => "重庆酒店",
	  		:url => "http://hotel.tuniu.com/city_300"
        },
        {
	  		:name => "宁波酒店",
	  		:url => "http://hotel.tuniu.com/city_3415"
        },
        {
	  		:name => "西安酒店",
	  		:url => "http://hotel.tuniu.com/city_2702"
        },
        {
	  		:name => "温州酒店",
	  		:url => "http://hotel.tuniu.com/city_3426"
        },
        {
	  		:name => "常州酒店",
	  		:url => "http://hotel.tuniu.com/city_1604"
        },
        {
	  		:name => "无锡酒店",
	  		:url => "http://hotel.tuniu.com/city_1619"
        },
        {
	  		:name => "长沙酒店",
	  		:url => "http://hotel.tuniu.com/city_1502"
        },
        {
	  		:name => "大连酒店",
	  		:url => "http://hotel.tuniu.com/city_1906"
        },
        {
	  		:name => "厦门酒店",
	  		:url => "http://hotel.tuniu.com/city_414"
        },
        {
	  		:name => "太原酒店",
	  		:url => "http://hotel.tuniu.com/city_2602"
        },
        {
	  		:name => "济南酒店",
	  		:url => "http://hotel.tuniu.com/city_2402"
        },
        {
	  		:name => "广州酒店",
	  		:url => "http://hotel.tuniu.com/city_602"
        },
        {
	  		:name => "丽江酒店",
	  		:url => "http://hotel.tuniu.com/city_3312"
        },
        {
	  		:name => "三亚酒店",
	  		:url => "http://hotel.tuniu.com/city_906"
        },
        {
	  		:name => "香港酒店",
	  		:url => "http://hotel.tuniu.com/city_1302"
        }
        ]
    def self.category_list
      ACATEL.map do |elem|

        {
          :url => elem[:url],
          :name => elem[:name]
        }
      end
    end
  end
end
