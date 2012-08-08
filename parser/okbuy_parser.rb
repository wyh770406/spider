# encoding: utf-8
require "nokogiri"

module Spider
  class OkbuyParser < Parser
    CATEGORY_MAP = [
["女鞋-平跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-低跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-中跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-高跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-超高跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-坡跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-粗跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-细跟靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-流苏靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-雪地靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-鱼嘴靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-罗马靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-松糕靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-防水台", "鞋帽服饰-女鞋-靴子"],
["女鞋-短靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-中筒靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-高筒靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-过膝靴", "鞋帽服饰-女鞋-靴子"],
["女鞋-平跟鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-低跟鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-中跟鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-高跟鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-超高跟", "鞋帽服饰-女鞋-单鞋"],
["女鞋-坡跟鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-粗跟鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-细跟鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-浅口鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-套脚鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-系带鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-扣带鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-包头鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-圆头鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-方头鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-尖头鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-芭蕾鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-娃娃鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-鱼嘴鞋", "鞋帽服饰-女鞋-单鞋"],
["女鞋-防水台", "鞋帽服饰-女鞋-单鞋"],
["女鞋-帆布鞋", "鞋帽服饰-女鞋-帆布鞋"],
["女鞋-马丁靴", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-果冻鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-糖果色", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-漆皮鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-软木底", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-豹纹", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-水钻", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-花朵", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-流苏", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-蝴蝶结", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-塑身鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-松糕鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-铆钉", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-扣带", "鞋帽服饰-女鞋-流行休闲鞋"],
["女鞋-跑步鞋", "鞋帽服饰-运动休闲鞋-跑步鞋"],
["女鞋-网球鞋", "运动户外-运动名品-网球用品"],
["女鞋-训练鞋", "运动户外-运动名品-运动鞋"],
["女鞋-板鞋", "鞋帽服饰-运动休闲鞋-板鞋"],
["女鞋-运动拖鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
["女鞋-运动凉鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
["男鞋-休闲时尚鞋", "鞋帽服饰-男鞋-商务休闲鞋"],
["男鞋-休闲正装鞋", "鞋帽服饰-男鞋-正装鞋"],
["男鞋-户外休闲鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
["男鞋-靴子高帮鞋", "鞋帽服饰-男鞋-靴子"],
["男鞋-登山鞋", "运动户外-运动名品-运动鞋"],
["男鞋-徒步鞋", "运动户外-运动名品-运动鞋"],
["男鞋-复古鞋", "运动户外-运动名品-运动鞋"],
["男鞋-板鞋", "鞋帽服饰-运动休闲鞋-板鞋"],
["男鞋-帆布鞋", "鞋帽服饰-运动休闲鞋-帆布鞋  "],
["男鞋-篮球鞋", "鞋帽服饰-运动休闲鞋-篮球鞋"],
["男鞋-足球鞋", "鞋帽服饰-运动休闲鞋-足球鞋"],
["男鞋-跑步鞋", "鞋帽服饰-运动休闲鞋-跑步鞋"],
["男鞋-网球鞋", "运动户外-运动名品-网球用品"],
["男鞋-训练鞋", "运动户外-运动名品-运动鞋"],
["男鞋-越野跑鞋", "鞋帽服饰-男鞋-其他款"],
["男鞋-赛车鞋", "鞋帽服饰-男鞋-其他款"],
["男鞋-拖鞋", "鞋帽服饰-男鞋-凉拖/拖鞋"],
["男鞋-低帮鞋", "鞋帽服饰-男鞋-其他款"],
["男鞋-高帮鞋", "鞋帽服饰-男鞋-其他款"],
["男鞋-沙滩鞋", "鞋帽服饰-男鞋-其他款"],
["运动鞋-篮球鞋", "鞋帽服饰-运动休闲鞋-篮球鞋"],
["运动鞋-足球鞋", "鞋帽服饰-运动休闲鞋-足球鞋"],
["运动鞋-网球鞋", "运动户外-运动名品-运动鞋"],
["运动鞋-排球鞋", "运动户外-运动名品-运动鞋"],
["运动鞋-乒乓球鞋", "运动户外-运动名品-运动鞋"],
["运动鞋-羽毛球鞋", "鞋帽服饰-运动休闲鞋-羽毛球鞋"],
["运动鞋-跑步鞋", "鞋帽服饰-运动休闲鞋-跑步鞋"],
["运动鞋-训练鞋", "运动户外-运动名品-运动鞋"],
["运动鞋-板鞋", "鞋帽服饰-运动休闲鞋-板鞋"],
["运动鞋-运动休闲鞋", "鞋帽服饰-运动休闲鞋-休闲鞋"],
["运动鞋-帆布鞋", "鞋帽服饰-运动休闲鞋-帆布鞋  "],
["运动鞋-越野跑鞋", "运动户外-运动名品-运动鞋"],
["运动鞋-轻闲鞋", "鞋帽服饰-运动休闲鞋-休闲鞋"],
["运动鞋-赛车鞋", "运动户外-运动名品-运动鞋"],
["运动鞋-硫化鞋", "运动户外-运动名品-运动鞋"],
["运动鞋-跑步鞋", "鞋帽服饰-运动休闲鞋-跑步鞋"],
["运动鞋-复古鞋", "鞋帽服饰-运动休闲鞋-休闲鞋"],
["运动鞋-板鞋", "鞋帽服饰-运动休闲鞋-板鞋"],
["户外鞋-户外凉鞋", "鞋帽服饰-其他鞋-凉鞋"],
["户外鞋-户外拖鞋", "鞋帽服饰-其他鞋-凉鞋"],
["户外鞋-登山鞋", "鞋帽服饰-运动休闲鞋-登山鞋"],
["户外鞋-徒步鞋", "运动户外-运动名品-运动鞋"],
["户外鞋-户外休闲鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
["户外鞋-凉鞋", "鞋帽服饰-其他鞋-凉鞋"],
["户外鞋-沙滩鞋", "运动户外-运动名品-运动鞋"],
["户外鞋-攀岩鞋", "运动户外-户外装备-登山攀岩"],
["户外鞋-越野跑鞋", "运动户外-运动名品-运动鞋"],
["户外鞋-溯溪鞋", "运动户外-运动名品-运动鞋"],
["户外鞋-速干", "运动户外-运动名品-运动鞋"],
["户外鞋-冲锋衣", "运动户外-运动名品-运动服装"],
["户外鞋-冲锋裤", "运动户外-运动名品-运动服装"],
["童鞋-篮球鞋", "鞋帽服饰-童鞋-运动鞋"],
["童鞋-网球鞋", "鞋帽服饰-童鞋-运动鞋"],
["童鞋-跑步鞋", "鞋帽服饰-童鞋-运动鞋"],
["童鞋-训练鞋", "鞋帽服饰-童鞋-运动鞋"],
["童鞋-板鞋", "鞋帽服饰-运动休闲鞋-板鞋"],
["童鞋-休闲时尚鞋", "鞋帽服饰-运动休闲鞋-休闲鞋"],
["童鞋-经典复古鞋", "鞋帽服饰-童鞋-其他款"],
["童鞋-帆布鞋", "鞋帽服饰-运动休闲鞋-帆布鞋  "],
["童鞋-户外凉鞋", "鞋帽服饰-其他鞋-凉鞋"],
["童鞋-户外拖鞋", "鞋帽服饰-其他鞋-拖鞋"],
["童鞋-登山鞋", "鞋帽服饰-运动休闲鞋-登山鞋"],
["童鞋-徒步鞋", "运动户外-运动名品-运动鞋"],
["童鞋-户外休闲鞋", "鞋帽服饰-运动休闲鞋-休闲鞋"],
["童鞋-中筒靴", "鞋帽服饰-其他鞋-靴子"],
["童鞋-凉鞋", "鞋帽服饰-其他鞋-凉鞋"],
["童鞋-凉拖", "鞋帽服饰-其他鞋-拖鞋"],
["童鞋-越野跑鞋", "鞋帽服饰-运动休闲鞋-跑步鞋"],
["童鞋-宝宝鞋", "鞋帽服饰-童鞋-其他款"],
["童鞋-学步鞋", "鞋帽服饰-童鞋-学步鞋"],
["童鞋-运动鞋", "鞋帽服饰-童鞋-运动鞋"],
["服装-羽绒服", "服装-运动服装-棉服"],
["服装-棉服", "服装-运动服装-棉服"],
["服装-长袖T恤", "服装-运动服装-运动T恤"],
["服装-长袖POLO衫", "服装-运动服装-运动休闲"],
["服装-短袖T恤", "服装-运动服装-运动T恤"],
["服装-长袖衬衫", "服装-女装-衬衫"],
["服装-外套", "服装-运动服装-运动外套"],
["服装-夹克", "服装-运动服装-卫衣"],
["服装-针织套头衫", "服装-女装-针织衫"],
["服装-短袖POLO衫", "服装-女装-衬衫"],
["服装-短袖衬衫", "服装-女装-衬衫"],
["服装-背心", "服装-内衣袜品-背心"],
["服装-户外装", "运动户外-运动名品-运动服装"],
["服装-运动衣", "运动户外-运动名品-运动服装"],
["服装-运动裤", "运动户外-运动名品-运动服装"],
["包-手提包", "箱包皮具-潮流女包-手提包"],
["包-单肩斜跨包", "箱包皮具-潮流女包-单肩/斜跨两用包"],
["包-双肩背包", "箱包皮具-旅行箱包-双肩包"],
["包-腰包", "箱包皮具-旅行箱包-腰包"],
["包-钱包", "箱包皮具-时尚男包-钱包"],
["包-时尚女包", "箱包皮具-旅行箱包-休闲包"],
["包-男士公文包", "箱包皮具-时尚男包-经典商务包"],
["包-多功能包", "箱包皮具-旅行箱包-多功能背包"],
["配件-水壶", "家居家纺-厨房用具-水壶"],
["配件-鞋垫", "鞋帽服饰-服饰配饰-其他配饰"],
["配件-帽子", "鞋帽服饰-服饰配饰-帽子"],
["配件-手套", "鞋帽服饰-服饰配饰-手套"],
["配件-围巾", "鞋帽服饰-服饰配饰-围巾"],
["配件-腰带", "鞋帽服饰-服饰配饰-腰带"],
["配件-触屏腕表", "珠宝配饰-手表钟表-其他表"],
["配件-户外手表", "珠宝配饰-手表钟表-其他表"],
["配件-自充气垫", "鞋帽服饰-服饰配饰-其他配饰"]
	]
    
	URL = "http://www.okbuy.com"
	def belongs_to_categories

      product_page_category_url = product.page.category.url

      if product_page_category_url.index("category=shoes&gender=2") || product_page_category_url.index("ifwomen=1")  || product_page_category_url.index("gender=2")
        top_url = "http://www.okbuy.com/product/search?category=women_shoes&gender=2"
        top_name = "女鞋"

      elsif product_page_category_url.index("category=shoes&gender=1") || product_page_category_url.index("gender=1")
        top_url = "http://www.okbuy.com/product/search?category=men_shoes&gender=1"
        top_name = "男鞋"
      elsif product_page_category_url.index("category=sport_shoes")
        top_url = "http://www.okbuy.com/product/search?category=sport_shoes"
        top_name = "运动鞋"

      elsif product_page_category_url.index("category=outdoor_shoes")
        top_url = "http://www.okbuy.com/product/search?category=outdoor_shoes"
        top_name = "户外鞋"
      elsif product_page_category_url.index("category=shoes&gender=4")
        top_url = "http://www.okbuy.com/product/search?category=child_shoes&gender=4"
        top_name = "童鞋"

      elsif product_page_category_url.index("category=clothes")
        top_url = "http://www.okbuy.com/product/search?category=clothes"
        top_name = "服装"

      elsif product_page_category_url.index("category=bags")
        top_url = "http://www.okbuy.com/product/search?category=bags"
        top_name = "包"
      elsif product_page_category_url.index("category=accessories")
        top_url = "http://www.okbuy.com/product/search?category=accessories"
        top_name = "配件"
      end
             
		[
		  {
		    :name => top_name,
		    :url  => top_url
		  },
		  {
		    :name => product.page.category.name,
		    :url  => product.page.category.url
		  }

		]


	#  doc.css("div.dCurrent a").select{|elem| elem["href"] && elem["href"].to_s != "/"}.map do |elem|
	#  {
	#	:name => elem.inner_text,
	#	:url => [URL, elem["href"]].join
	#  }
	#  end 
	end

	def title
      doc.css("h1.pProductTitleName strong").text.strip
	end

	def price
	  doc.css("p.textPriceOur em").text[/\d+/].to_f
	end

	def stock
      return 1 
	end

	def image_url
      doc.css("p.pBigPic img").first["src"]
	end

	def desc
	end

	def price_url
	end

	def score
	 doc.css("span.pStarWhite").blank? ? 5 : 0
	end

	def product_code
	  doc.css("ul.pProductTitle li:first p").text
	end

	def standard
	end

	def get_union_url
      product.url+"?from=trackingid_office-24968"
	end

	def comments
      title_elems      = doc.css(".pCommentList")
      content_elems    = doc.css(".pCommentList pCommC")
      publish_at_elems = doc.css(".pCommentList li.fr")
      star_elems       = doc.css(".pCommentList span.pStarWhite")
      (0..title_elems.count-1).map do |i|
        {
          :title      => title_elems[i].inner_text,
          :content    => content_elems[i].inner_text.sub(/[\s\d:-]+/, ""),
          :publish_at => publish_at_elems[i].to_s.empty? ? Time.now : Time.parse(publish_at_elems[i].to_s),
          :star       => star_elems[i] ? 5 : 0
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
      get_merchant("好乐买")
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

  
  end

end
