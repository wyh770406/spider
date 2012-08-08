# encoding: utf-8
require 'nokogiri'

module Spider
  class BailingkeParser < Parser
    CATEGORY_MAP = [
["绿色蔬菜-精品蔬菜", "食品/保健品-粮油生鲜-蔬果"],
["绿色蔬菜-有机蔬菜", "食品/保健品-粮油生鲜-蔬果"],
["可口水果-进口水果", "食品/保健品-粮油生鲜-蔬果"],
["可口水果-国产水果", "食品/保健品-粮油生鲜-蔬果"],
["可口水果-即食水果", "食品/保健品-粮油生鲜-蔬果"],
["禽鱼肉蛋-鸡肉", "食品/保健品-粮油生鲜-其他食品"],
["禽鱼肉蛋-鸭肉", "食品/保健品-粮油生鲜-其他食品"],
["禽鱼肉蛋-鱼类", "食品/保健品-粮油生鲜-其他食品"],
["禽鱼肉蛋-牛肉", "食品/保健品-粮油生鲜-其他食品"],
["禽鱼肉蛋-羊肉", "食品/保健品-粮油生鲜-其他食品"],
["禽鱼肉蛋-猪肉", "食品/保健品-粮油生鲜-其他食品"],
["禽鱼肉蛋-蛋类", "食品/保健品-粮油生鲜-有机食品"],
["果汁饮料-果汁", "食品/保健品-酒水饮料-饮料"],
["果汁饮料-茶饮料", "食品/保健品-酒水饮料-饮料"],
["果汁饮料-碳酸饮料", "食品/保健品-酒水饮料-饮料"],
["果汁饮料-功能饮料", "食品/保健品-酒水饮料-饮料"],
["果汁饮料-水", "食品/保健品-酒水饮料-饮料"],
["营养配菜", "食品/保健品-粮油生鲜-其他食品"],
["宅配套餐-农家鸡宅配", "食品/保健品-粮油生鲜-其他食品"],
["宅配套餐-绿色蔬菜宅配", "食品/保健品-粮油生鲜-其他食品"],
["单位福利卡-1000元福利卡", "其他-礼品/礼物-礼品礼券"],
["单位福利卡-500元福利卡", "其他-礼品/礼物-礼品礼券"],
["单位福利卡-300元福利卡", "其他-礼品/礼物-礼品礼券"],
["单位福利卡-100元福利卡", "其他-礼品/礼物-礼品礼券"],
["粮油食品-食用油", "食品/保健品-粮油生鲜-食用油"],
["粮油食品-大米", "食品/保健品-其他食品-米面"],
["粮油食品-精面粉", "食品/保健品-其他食品-米面"],
["营养配菜-营养配菜", "食品/保健品-保健品-其他保健品"],
["用户套餐-儿童成长", "母婴-宝贝食品-米粉等辅食"],
["用户套餐-孕妈养护", "食品/保健品-保健品-其他保健品"],
["用户套餐-中老年保健", "食品/保健品-保健品-传统滋补"],
["用户套餐-美容养颜", "食品/保健品-保健品-传统滋补"],
["用户套餐-白领健康", "食品/保健品-保健品-其他保健品"],
["用户套餐-三高人群", "食品/保健品-保健品-其他保健品"]
    ]
    BASE_URL = "http://www.bailingke.com/"
  
        def belongs_to_categories
	      doc.css("div#ur_here a").select{|elem| elem["href"] && elem["href"].to_s =~ /category/}.map do |elem|
	      {
		    :name => elem.inner_text,
		    :url => [BASE_URL, elem["href"]].join
	      }
	      end
           
	    end
	
		def title
		  doc.css("form#ECS_FORMBUY div.clearfix").text.strip
		end
	
		def price
         # doc.css("font#ECS_SHOPPRICE").text.strip.split("￥")[1].to_f  
                 doc.css("font#ECS_SHOPPRICE").text.match(/[\d|\.]+$/)[0].to_f
		end
	
		def stock
		  return 1
		end
	
		def desc
		end
	
		def price_url
		
		end
	
		def score
		  doc.css("li.clearfix dd img[alt]").first["src"][/\d+/].to_i
		end
	
		def product_code
		  doc.css("li.clearfix:first dd").text.strip.split("：")[1]
		end
	
		def standard
		end
	
		def comments
		end
	    
		def image_url
		 "http://www.bailingke.com/" + doc.css("div.imgInfo img[alt]").first["src"] 
		end

    def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      puts route_str
      origin_base_map(CATEGORY_MAP,route_str)
		end

		def merchant
      get_merchant("白领客")
		end

		def brand
		end

		def brand_type
		
		end

    def get_order_num
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")

      order_num_end_product = origin_base_map(CATEGORY_MAP,route_str)

      if order_num_end_product.nil?
        10000000
      else
        order_num_end_product.order_num
      end


    end
    def get_union_url
      product.url
    end
  end
end

