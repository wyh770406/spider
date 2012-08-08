#encoding: utf-8
require "nokogiri"

module Spider
  class Pb89Parser < Parser
    CATEGORY_MAP = [
["时尚女装-外套-风衣", "服装-女装-外套"],
["时尚女装-外套-羽绒衣", "服装-女装-外套"],
["时尚女装-外套-皮衣", "服装-女装-皮衣"],
["时尚女装-外套-休闲上衣", "服装-特色服装-休闲装"],
["时尚女装-外套-大衣", "服装-女装-外套"],
["时尚女装-外套-西服", "服装-女装-西服/套装"],
["时尚女装-外套-棉衣", "服装-运动服装-棉服"],
["时尚女装-外套-短外套", "服装-女装-外套"],
["时尚女装-上装-开襟衫", "服装-女装-衬衫"],
["时尚女装-上装-T恤", "服装-女装-T恤"],
["时尚女装-上装-衬衫", "服装-女装-衬衫"],
["时尚女装-上装-针织衫", "服装-女装-针织衫"],
["时尚女装-上装-坎肩马甲", "服装-女装-衬衫"],
["时尚女装-上装-卫衣", "服装-女装-外套"],
["时尚女装-上装-毛衫/毛衣", "服装-女装-针织衫"],
["时尚女装-上装-抹胸", "服装-内衣袜品-文胸"],
["时尚女装-上装-吊带/背心", "服装-内衣袜品-吊带"],
["时尚女装-裤装-长裤", "服装-女装-裤子"],
["时尚女装-裤装-短裤", "服装-女装-裤子"],
["时尚女装-裤装-裤袜", "服装-女装-裤子"],
["时尚女装-裤装-牛仔裤", "服装-女装-裤子"],
["时尚女装-裤装-中裤", "服装-女装-裤子"],
["时尚女装-裤装-落档裤", "服装-女装-裤子"],
["时尚女装-裤装-背带裤", "服装-女装-裤子"],
["时尚女装-裙装-半身裙", "服装-女装-裙子"],
["时尚女装-裙装-连衣裙", "服装-女装-裙子"],
["风尚男装-外套-正装/西服", "服装-男装-西服"],
["风尚男装-外套-夹克", "服装-男装-上衣外套"],
["风尚男装-外套-卫衣", "服装-男装-上衣外套"],
["风尚男装-外套-羽绒衣", "服装-男装-上衣外套"],
["风尚男装-外套-棉衣", "服装-运动服装-棉服"],
["风尚男装-外套-大衣/风衣", "服装-男装-上衣外套"],
["风尚男装-上衣-男装衬衫", "服装-男装-衬衫"],
["风尚男装-上衣-毛衣/毛衫", "服装-男装-针织"],
["风尚男装-上衣-马甲/背心", "服装-内衣袜品-背心"],
["风尚男装-上衣-T恤", "服装-男装-T恤"],
["风尚男装-上衣-针织衫", "服装-男装-针织"],
["风尚男装-裤装-牛仔裤", "服装-男装-裤子"],
["风尚男装-裤装-休闲裤", "服装-男装-裤子"],
["风尚男装-裤装-西裤", "服装-男装-裤子"],
["精品配饰-鞋类-靴子", "鞋帽服饰-其他鞋-靴子"],
["精品配饰-头饰-帽子", "鞋帽服饰-服饰配饰-帽子"],
["精品配饰-头饰-眼镜", "鞋帽服饰-服饰配饰-眼镜"],
["精品配饰-头饰-项链", "珠宝配饰-饰品配饰-项链/项坠"],
["精品配饰-头饰-围巾", "鞋帽服饰-服饰配饰-围巾"],
["精品配饰-手链/手镯/手饰", "珠宝配饰-饰品配饰-手链/脚链"],
["精品配饰-时尚包包", "箱包皮具-奢侈品-其他"],
["精品配饰-其它", "珠宝配饰-其他配饰-其他"]
	]
    URL = "http://www.pb89.com"
	def belongs_to_categories
	  doc.css("div.path a").select{|elem| elem["href"] && elem["href"].to_s =~ /html/ && elem["href"].to_s !~ /index/}.map do |elem|
	  {
		:name => elem.inner_text,
		:url => [URL, elem["href"]].join
	  }
	  end
	end
    
    def title
	  doc.css("div.goods_right_parameters h2").text.strip
	end
    

	def price
      doc.css("p.price_hot b.hot2").text[/\d+/].to_f

	end

	def stock
	  doc.css("span#storage").text.to_i
	end

	def image_url
      doc.css("img#goods_pic").first["src"]
	end

	def desc
	 # doc.css(".goods_detail").inner_html
	end

	def price_url
	end

	def score
	  doc.css("span[class^=star]").first["class"][/\d+/, 0].to_i
	end

	def product_code
	  doc.css("span#goods_sn").text 
	end

	def standard
	
	end

	def get_union_url
           product.url+"?u=1130813"
	end

	def comments
	 
	end

	def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      puts route_str
      origin_base_map(CATEGORY_MAP,route_str)
	end

	def merchant
      get_merchant("太平鸟")
	end

	def brand
	  #doc.css("p.para_1").first.inner_text.split("：")[1]
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
  end

end
