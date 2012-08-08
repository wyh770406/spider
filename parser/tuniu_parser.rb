#encoding: utf-8
require "nokogiri"

module Spider
  class TuniuParser < Parser
    CATEGORY_MAP = [
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
["度假酒店-度假酒店-度假酒店", "旅游酒店机票-酒店-国内酒店"],
["景区门票-景区门票-上海", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-江苏", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-北京", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-浙江", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-澳门", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-香港", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-福建", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-四川", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-江西", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-湖南", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-湖北", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-广东", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-重庆", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-安徽", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-海南", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-广西", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-山东", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-宁夏", "旅游酒店机票-景点门票-国内景点门票"],
["景区门票-景区门票-河南", "旅游酒店机票-景点门票-国内景点门票"],
["邮轮-豪华邮轮-邮轮旅游", "旅游酒店机票-旅游团-出境游"],
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
		  search_word = ["div#hotel_breadcrumb a.cgreen", "div#breadcrumb a.cgreen", "div#tourMeta a.cgreen"]
		  search_word.each do |key_word|
		    if doc.search(key_word).present?
			  category = doc.css(key_word).map do |elem|
		        {
				  :name => elem.inner_text,
				  :url => elem["href"]
			    }
		      end
			end
		  end
		  return category
		end
	
		def title
		  search_word = ["div#tourInfo.clear h1 a", "div#hotel-name.lucene h1", "div#ticket_intro_hd h1 a.cgreen", "div#youlun_info h1 a"]
		  title = ""
		  search_word.each do |key_word|
		    if doc.search(key_word).present?
			  title = doc.css(key_word).text
			end
		  end
		  return title
		end
	
		def price
		  search_word = ["ul#tourPrice li span.fb font.cdyellow.f18", "div.hotel_price strong", "span.youlun_price"]
		  price = 0
		  search_word.each do |key_word|
		    if doc.search(key_word).first.present?
		      price = doc.css(key_word).first.text.to_i
		    end
		  end
		  return price
		end
	
		def stock
		  return 1
		end
	
		def desc
		end
	
		def price_url
		
		end
	
		def score
		  doc.css("span.getStar5").first["class"][/\d+/, 0].to_i if doc.search("span.getStart5").present?
		end
	
		def product_code
		  doc.css("div#tourMeta strong").text[/\d+/, 0].to_i
		end
	
		def standard
		end
	
		def comments
		  if doc.search("div.recall_t").present?
			content_elems = doc.css("dd.recall_txt")
			publish_at_elems = doc.css("div.recall_t")
			(0...content_elems.count).map do |index|
			  {
				  publish_at: publish_at_elems[index].inner_text[/\d{4}-\d{2}-\d{2}/, 0],
				  content: content_elems[index].inner_text
			  }
			end
		  else	  
		    content_elems = doc.css("dd.recall_txt")
		    publish_at_elems = doc.css("div.recall_content dl dt span")
		    (0...content_elems.count).map do |index|
		      {
				publish_at: publish_at_elems[index].inner_text,
	            content: content_elems[index].inner_text.strip
			  }
		    end
		  end
		end
	    
		def image_url
		  search_word = ["img#tourHeadPhotoShow", "div.panel a img", "ul.common-rc li a img"]
		  img = ""
	      search_word.each do |word|
		    if doc.search(word).present?
		      img = doc.css(word).first["src"]
			end
		  end
		  return img
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
