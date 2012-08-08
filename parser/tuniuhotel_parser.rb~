#encoding: utf-8
require "nokogiri"

module Spider
  class TuniuhotelParser < Parser
    CATEGORY_MAP = [
["度假酒店-北京酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-上海酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-南京酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-杭州酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-苏州酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-天津酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-深圳酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-成都酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-武汉酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-青岛酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-沈阳酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-重庆酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-宁波酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-西安酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-温州酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-常州酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-无锡酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-长沙酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-大连酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-厦门酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-太原酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-济南酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-广州酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-丽江酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-三亚酒店", "旅游酒店机票-酒店-国内酒店"],
["度假酒店-香港酒店", "旅游酒店机票-酒店-国外酒店"]


   ]


    def belongs_to_categories

			   doc.css("div#breadcrumb a.cgreen").select{|elem| elem["href"] && elem["href"].to_s !~ /tuniu/}.map do |elem|
		        {
                                
				  :name => elem.inner_text,
				  :url => "http://hotel.tuniu.com"+elem["href"]
			    }
		      end

		end
	
		def title

                  doc.css("div.lucene h1").text

		end
	
		def price
                  doc.css("span#price-num").text.to_f

		end
	
		def stock
		  return 1
		end
	
		def desc
		end
	
		def price_url
		
		end
	
		def score
		  #doc.css("span.getStar5").first["class"][/\d+/, 0].to_i if doc.search("span.getStart5").present?
		end
	
		def product_code
		  #doc.css("div#tourMeta strong").text[/\d+/, 0].to_i
		end
	
		def standard
		end
	
		def comments
                  []
		end
	    
		def image_url
                   doc.css(".room-pic img").first[:src] if doc.css(".room-pic img").first

		end

    def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      puts route_str
      origin_base_map(CATEGORY_MAP,route_str)
		end

		def merchant
                  get_merchant("途牛旅游网")
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
      "http://market.tuniu.com/Partner_redirect.php?p=9057&cmpid=union_9057&url="+product.url
    end

  end
end
