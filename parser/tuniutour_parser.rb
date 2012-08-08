#encoding: utf-8
require "nokogiri"

module Spider
  class TuniutourParser < Parser
    CATEGORY_MAP = [
["国内旅游","旅游酒店机票-旅游团-国内游"],
["周边旅游","旅游酒店机票-旅游团-国内游"],
["公司旅游","旅游酒店机票-旅游团-国内游"],
["自助游","旅游酒店机票-旅游团-出境游"],
["出境旅游", "旅游酒店机票-旅游团-出境游"],
["周边旅游-周边旅游-温泉", "旅游酒店机票-旅游团-国内游"],
["周边旅游-周边旅游-滑雪", "旅游酒店机票-旅游团-国内游"],
["周边旅游-周边旅游-城市", "旅游酒店机票-旅游团-国内游"],
["周边旅游-周边旅游-山西文化游", "旅游酒店机票-旅游团-国内游"],
["周边旅游-周边旅游-山水", "旅游酒店机票-旅游团-国内游"],
["周边旅游-周边旅游-人文", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-海南", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-云南", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-四川", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-湖南", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-华东", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-东北", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-河南", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-西藏", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-广西", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-福建", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-陕西", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-湖北", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-三峡", "旅游酒店机票-旅游团-国内游"],
["国内旅游-国内旅游-江西", "旅游酒店机票-旅游团-国内游"],
["出境旅游-出境旅游-自助游", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-签证办理", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-东南亚", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-南亚", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-日本", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-韩国", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-港澳", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-澳洲", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-欧洲", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-美洲", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-非洲中东", "旅游酒店机票-旅游团-出境游"],
["出境旅游-出境旅游-邮轮", "旅游酒店机票-旅游团-出境游"],
["自助游-国内旅游-海南", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-云南", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-四川", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-湖南", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-华东", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-东北", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-河南", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-西藏", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-广西", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-福建", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-陕西", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-湖北", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-三峡", "旅游酒店机票-旅游团-国内游"],
["自助游-国内旅游-江西", "旅游酒店机票-旅游团-国内游"],
["自助游-出境旅游-自助游", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-签证办理", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-东南亚", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-南亚", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-日本", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-韩国", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-港澳", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-澳洲", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-欧洲", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-美洲", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-非洲中东", "旅游酒店机票-旅游团-出境游"],
["自助游-出境旅游-邮轮", "旅游酒店机票-旅游团-出境游"],
["公司旅游-周边旅游-温泉滑雪", "旅游酒店机票-旅游团-国内游"],
["公司旅游-周边旅游-城市", "旅游酒店机票-旅游团-国内游"],
["公司旅游-周边旅游-山水", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-海南会议会展", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-周边团队游", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-云南", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-海南", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-华东", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-福建", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-广西", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-山东", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-大连", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-四川", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-湖南", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-贵州", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-中原", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-东北", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-湖北", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-重庆", "旅游酒店机票-旅游团-国内游"],
["公司旅游-国内旅游-内蒙", "旅游酒店机票-旅游团-国内游"]
   ]


        def belongs_to_categories
                        product.cate_path

	    end
	
		def title
		  return   doc.css("img#tourHeadPhotoShow").first["alt"] if doc.css("img#tourHeadPhotoShow").first
                  return doc.title.split("_").first if doc.title.split("_").first.strip != ""
		end
	
		def price
                  
		  return   doc.css("ul#tourPrice li:first span.fb font.cdyellow.f18").first.text.to_f if doc.css("ul#tourPrice li:first span.fb font.cdyellow.f18").first
                  return doc.css(".tn_price").first.text.to_f if doc.css(".tn_price").first
                end
	
		def stock
		  return 1
		end
	
		def desc
		end
	
		def price_url
		
		end
	
		def score
		  return 0
		end
	
		def product_code
		  doc.css("div#tourMeta strong").text[/\d+/, 0].to_i
		end
	
		def standard
		end
	
		def comments
		  content_elems = doc.css("dd.recall_txt")
		  publish_at_elems = doc.css("div.recall_content dl dt span")
		  (0...content_elems.count).map do |index|
		  {
			publish_at: publish_at_elems[index].inner_text,
	        content: content_elems[index].inner_text.strip
		  }
		  end
		end
	    
		def image_url
		 return doc.css("img#tourHeadPhotoShow").first["src"] if doc.css("img#tourHeadPhotoShow").first
                 return doc.css(".common-rc.cf li:first img").first[:src] if doc.css(".common-rc.cf li:first img").first
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

