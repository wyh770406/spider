#encoding: utf-8
require 'nokogiri'

module Spider
  class UbaoParser < Parser
    CATEGORY_MAP = [
["境外旅游保险", "保险按揭-旅游保险-境外旅游保险"],
["境内旅游保险", "保险按揭-旅游保险-境内旅游保险"],
["签证保险", "保险按揭-签证保险-长期境外留学"],
["交通保险", "保险按揭-车辆保险-第三者责任险"],
["人身意外", "保险按揭-意外保险-综合意外伤害险"],
["医疗/疾病", "保险按揭-医疗保险-重大疾病保险"],
["驾驶员意外", "保险按揭-车辆保险-车辆停驶损失保险"],
["储蓄理财", "保险按揭-投资理财-万能险"]
]
 
    BASE_URL = "http://www.ubao.com"
		def belongs_to_categories

        [ 
         {
            :name => product.page.category.name,
            :url  => product.page.category.url
          }

        ]
     # doc.css(".catnav a").map{|elem| {:url => File.join(BASE_URL, elem[:href]), :name => elem.inner_text}}
		end

    def title
	    return doc.css("div.ins-name h1").text.strip if doc.css("div.ins-name h1").text.strip!=""
	    return doc.css("td.norate h1").text.strip if doc.css("td.norate h1")
    end

    def price
	    doc.css("span.dblue").text[/\d+\.\d+/].to_f
		end

  	def stock
		  return 1 
  	end

  	def image_url
		  "http://www.ubao.com"+doc.css("div.ins-name img").first["src"] if doc.css("div.ins-name img").first.present?
		end

		def desc
		  doc.css("div#f_tabdetail").to_html
		end

		def price_url

		end

		def score
		  doc.css("#discussRes").first.try("next_sibling").try("text").to_f 
		end

		def product_code
		  
		end

		def standard

		end
		


		def comments
		  content_elems = doc.css("#disCussListShow .tgr label")
		  publish_at_elems =  doc.css("#disCussListShow .clear s")
		 (1..content_elems.count).map do |index|
		   {
				publish_at: publish_at_elems[index-1].text.gsub!(/(\[|\])/, ""),
				content: content_elems[index-1].text
			}
		  end	
		end

		def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      puts route_str
      origin_base_map(CATEGORY_MAP,route_str)
		end

		def merchant
                #  return Merchant.find(BSON::ObjectId("4e53c0aa1d41c862fc00057e"))
		end

		def brand
		#  doc.css("div.brandArea span strong a").inner_text
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
