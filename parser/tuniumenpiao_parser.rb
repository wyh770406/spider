#encoding: utf-8
require "nokogiri"

module Spider
  class TuniumenpiaoParser < Parser
    CATEGORY_MAP = [
["上海景区", "旅游酒店机票-景点门票-国内景点门票"],
["江苏景区", "旅游酒店机票-景点门票-国内景点门票"],
["北京景区", "旅游酒店机票-景点门票-国内景点门票"],
["浙江景区", "旅游酒店机票-景点门票-国内景点门票"],
["澳门景区", "旅游酒店机票-景点门票-国内景点门票"],
["香港景区", "旅游酒店机票-景点门票-国内景点门票"],
["福建景区", "旅游酒店机票-景点门票-国内景点门票"],
["四川景区", "旅游酒店机票-景点门票-国内景点门票"],
["江西景区", "旅游酒店机票-景点门票-国内景点门票"],
["湖南景区", "旅游酒店机票-景点门票-国内景点门票"],
["湖北景区", "旅游酒店机票-景点门票-国内景点门票"],
["广东景区", "旅游酒店机票-景点门票-国内景点门票"],
["重庆景区", "旅游酒店机票-景点门票-国内景点门票"],
["安徽景区", "旅游酒店机票-景点门票-国内景点门票"],
["海南景区", "旅游酒店机票-景点门票-国内景点门票"],
["广西景区", "旅游酒店机票-景点门票-国内景点门票"],
["山东景区", "旅游酒店机票-景点门票-国内景点门票"],
["宁夏景区", "旅游酒店机票-景点门票-国内景点门票"],
["河南景区", "旅游酒店机票-景点门票-国内景点门票"],
["山西景区", "旅游酒店机票-景点门票-国内景点门票"],
["吉林景区", "旅游酒店机票-景点门票-国内景点门票"],
["辽宁景区", "旅游酒店机票-景点门票-国内景点门票"],
["云南景区", "旅游酒店机票-景点门票-国内景点门票"],
["贵州景区", "旅游酒店机票-景点门票-国内景点门票"],
["新疆景区", "旅游酒店机票-景点门票-国内景点门票"],
["台湾景区", "旅游酒店机票-景点门票-国内景点门票"],
["青海景区", "旅游酒店机票-景点门票-国内景点门票"],
["甘肃景区", "旅游酒店机票-景点门票-国内景点门票"],
["河北景区", "旅游酒店机票-景点门票-国内景点门票"],
["陕西景区", "旅游酒店机票-景点门票-国内景点门票"],
["西藏景区", "旅游酒店机票-景点门票-国内景点门票"],
["天津景区", "旅游酒店机票-景点门票-国内景点门票"]    ]


        def belongs_to_categories
	      doc.css("div#breadcrumb a.cgreen").select{|elem| elem["href"] && elem["href"].to_s =~ /area/}.map do |elem|
		  puts elem.inner_text
                 {
		    :name => elem.inner_text,
		    :url => "http://menpiao.tuniu.com"+elem["href"]
		  }
	      end
        end
	
		def title
          doc.css("div#ticket_intro_hd h1 a").text
		end
	
		def price
               doc.css("td.t_price").first.next_element.text.match(/[\d|\.]+$/)[0].to_f
          #doc.css("td.t_price").first.next_element.css("span").text.to_f
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
          doc.css("div.panel a img").first[:src] if doc.css("div.panel a img").first
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
