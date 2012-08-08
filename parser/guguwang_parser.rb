#encoding: utf-8
require 'nokogiri'

module Spider
  class GuguwangParser < Parser
    CATEGORY_MAP = [
["车内装饰用品-汽车座套", "汽车用品-车内饰品-座套/座垫 "],
["车内装饰用品-方向盘套", "汽车用品-车内饰品-方向盘套"],
["车内装饰用品-太阳能公仔", "汽车用品-车内饰品-摆件/挂饰"],
["车内装饰用品-汽车挂饰", "汽车用品-车内饰品-摆件/挂饰"],
["车内装饰用品-后视镜套", "汽车用品-车内饰品-各类物品套"],
["车内装饰用品-安全带套", "汽车用品-车内饰品-各类物品套"],
["车内装饰用品-卡通公仔", "汽车用品-车内饰品-卡通饰品"],
["车内装饰用品-排挡套", "汽车用品-车内饰品-各类物品套"],
["车内舒适用品-夏季凉垫", "汽车用品-车内饰品-座套/座垫 "],
["车内舒适用品-冬季毛垫", "汽车用品-车内饰品-座套/座垫 "],
["车内舒适用品-汽车抱枕", "汽车用品-车内饰品-头枕/颈枕"],
["车内舒适用品-汽车腰靠", "汽车用品-车内饰品-头枕/颈枕"],
["车内舒适用品-车用空调被", "汽车用品-车内饰品-其他"],
["车内舒适用品-汽车颈枕", "汽车用品-车内饰品-头枕/颈枕"],
["车内舒适用品-汽车布艺", "汽车用品-车内饰品-其他"],
["车内舒适用品-车载冰箱", "汽车用品-汽车电器-车载冰箱"],
["车内舒适用品-遮阳挡", "汽车用品-车内饰品-遮阳挡窗帘"],
["车内功能用品-年检袋", "汽车用品-车内饰品-其他"],
["车内功能用品-逆变器", "汽车用品-汽车电器-逆变器"],
["车内功能用品-助力把球", "汽车用品-车内用品-其他"],
["车内功能用品-手机架", "汽车用品-车内用品-其他"],
["车内功能用品-眼镜票据夹", "汽车用品-车内用品-其他"],
["车内功能用品-手机车充", "汽车用品-汽车电器-其他"],
["车内功能用品-点烟器", "汽车用品-汽车电器-其他"],
["车内功能用品-烟灰缸", "汽车用品-车内用品-其他"],
["车内功能用品-汽车钟表", "汽车用品-车内用品-其他"],
["车内功能用品-温湿度计", "汽车用品-车内用品-其他"],
["车内功能用品-指南针球", "汽车用品-车内用品-其他"],
["车内功能用品-防滑垫", "汽车用品-车内用品-其他"],
["车内功能用品-车用衣架", "汽车用品-车内用品-置物架"],
["汽车香水-水晶香水", "汽车用品-车内用品-空气净化"],
["汽车香水-高级香水", "汽车用品-车内用品-空气净化"],
["汽车香水-卡通香水", "汽车用品-车内用品-空气净化"],
["汽车香水-香水补充液", "汽车用品-车内用品-空气净化"],
["汽车香水-挂饰香水", "汽车用品-车内用品-空气净化"],
["汽车香水-汽车香罐", "汽车用品-车内用品-空气净化"],
["汽车香水-出风口香水", "汽车用品-车内用品-空气净化"],
["车内清洁用品-汽车脚垫", "汽车用品-车内饰品-脚垫"],
["车内清洁用品-后备箱垫", "汽车用品-车内饰品-座套/座垫 "],
["车内清洁用品-车用纸巾盒", "汽车用品-车内用品-其他"],
["车内清洁用品-擦车巾", "汽车用品-车内用品-其他"],
["车内清洁用品-皮革护理", "汽车用品-车内用品-其他"],
["车内清洁用品-车载吸尘器", "汽车用品-汽车电器-车用吸尘器"],
["车内空气清新-车用竹炭", "汽车用品-车内用品-空气净化"],
["车内空气清新-汽车除菌剂", "汽车用品-车内用品-空气净化"],
["车内空气清新-空气清新剂", "汽车用品-车内用品-空气净化"],
["车内空气清新-汽车氧吧", "汽车用品-车内用品-空气净化"],
["汽车防盗用品-方向盘锁", "汽车用品-安全防盗-防盗锁"],
["汽车防盗用品-排挡锁", "汽车用品-安全防盗-防盗锁"],
["汽车防盗用品-防盗器", "汽车用品-安全防盗-防盗器"],
["车主个人用品-驾驶证套", "汽车用品-车内饰品-各类物品套"],
["车主个人用品-车钥匙扣", "汽车用品-车内用品-钥匙扣/包"],
["车主个人用品-汽车CD盒", "汽车用品-车内用品-其他"],
["车主个人用品-车载剃须刀", "汽车用品-车内用品-其他"],
["车主个人用品-司机眼镜", "鞋帽服饰-服饰配饰-眼镜"],
["车主个人用品-赛车服帽", "鞋帽服饰-服饰配饰-帽子"],
["车主个人用品-打火机", "汽车用品-车内用品-其他"],
["汽车影音-车载MP3", "汽车用品-汽车电器-其他"],
["汽车影音-车载MP4", "汽车用品-汽车电器-其他"],
["汽车影音-蓝牙免提", "汽车用品-汽车电器-其他"],
["汽车影音-蓝牙耳机", "汽车用品-汽车电器-其他"],
["汽车影音-车载DVD", "汽车用品-汽车电器-其他"],
["汽车影音-汽车音响", "汽车用品-汽车电器-其他"],
["车外装饰与功能-汽车标志", "汽车用品-车内饰品-其他"],
["车外装饰与功能-金属小车贴", "汽车用品-车内饰品-其他"],
["车外装饰与功能-个性车贴", "汽车用品-车内饰品-其他"],
["车外装饰与功能-油箱贴", "汽车用品-车内饰品-其他"],
["车外装饰与功能-全车车贴", "汽车用品-车内饰品-其他"],
["车外装饰与功能-汽车天线", "汽车用品-车内饰品-其他"],
["车外装饰与功能-除静电带", "汽车用品-车内饰品-其他"],
["车外装饰与功能-装饰灯", "汽车用品-车内饰品-其他"],
["车外装饰与功能-车牌架", "汽车用品-车内饰品-其他"],
["车外装饰与功能-警示牌", "汽车用品-车内饰品-其他"],
["汽车护理与美容-底盘装甲", "汽车用品-养护用品-其他"],
["汽车护理与美容-镀膜釉", "汽车用品-养护用品-其他"],
["汽车护理与美容-光泽蜡", "汽车用品-养护用品-车蜡"],
["汽车护理与美容-去污蜡", "汽车用品-养护用品-车蜡"],
["汽车护理与美容-修复蜡", "汽车用品-养护用品-车蜡"],
["汽车护理与美容-轮胎蜡", "汽车用品-养护用品-车蜡"],
["汽车护理与美容-清洁剂", "汽车用品-养护用品-其他"],
["汽车护理与美容-清洁打蜡工具", "汽车用品-养护用品-蜡扫/掸子"],
["汽车护理与美容-防冻液", "汽车用品-养护用品-其他"],
["汽车护理与美容-汽车车衣", "汽车用品-养护用品-其他"],
["汽车护理与美容-汽车补漆笔", "汽车用品-养护用品-其他"],
["汽车护理与美容-防撞条", "汽车用品-养护用品-其他"],
["汽车护理与美容-抗磨修复剂", "汽车用品-养护用品-其他"],
["汽车护理与美容-水箱宝", "汽车用品-养护用品-其他"],
["汽车护理与美容-贴膜工具", "汽车用品-养护用品-其他"],
["汽车护理与美容-机油排挡油", "汽车用品-养护用品-其他"],
["安全驾驶用品-倒车摄像头", "汽车用品-汽车电器-其他"],
["安全驾驶用品-缓冲器", "汽车用品-汽车电器-其他"],
["安全驾驶用品-GPS导航", "汽车用品-导航通讯-GPS导航"],
["安全驾驶用品-行车记录仪", "汽车用品-导航通讯-GPS导航"],
["安全驾驶用品-倒车雷达", "汽车用品-导航通讯-倒车雷达"],
["安全驾驶用品-玻璃防雾剂", "汽车用品-导航通讯-其他"],
["安全驾驶用品-胎压计", "汽车用品-导航通讯-其他"],
["安全驾驶用品-打气泵", "汽车用品-汽车电器-打气泵"],
["安全驾驶用品-大视野镜", "汽车用品-车内用品-其他"],
["安全驾驶用品-防驾驶疲劳", "汽车用品-车内用品-其他"],
["安全驾驶用品-儿童安全椅", "汽车用品-安全防盗-儿童座椅"],
["应急用品-车用灭火器", "汽车用品-汽车电器-其他"],
["应急用品-警示三角架", "汽车用品-车内用品-其他"],
["应急用品-拖车绳", "汽车用品-车内用品-其他"],
["应急用品-暴闪灯", "汽车用品-车内用品-其他"],
["应急用品-维修工具", "汽车用品-养护用品-其他"],
["应急用品-启动电源", "汽车用品-导航通讯-车载电源"],
["汽车旅行用品-野营灯", "汽车用品-其他-其他"],
["汽车旅行用品-折叠桌椅", "汽车用品-其他-其他"],
["汽车旅行用品-野营工具", "汽车用品-其他-其他"],
["汽车旅行用品-帐篷睡袋", "汽车用品-其他-其他"],
["汽车旅行用品-背包背囊", "汽车用品-其他-其他"],
["汽车旅行用品-水壶水囊", "汽车用品-其他-其他"],
["汽车旅行用品-储备油箱", "汽车用品-其他-其他"],
["汽车旅行用品-对讲机", "汽车用品-其他-其他"],
["汽车照明-车顶灯", "汽车用品-其他-其他"],
["汽车照明-氙气灯", "汽车用品-其他-其他"],
["汽车照明-大灯增光器", "汽车用品-其他-其他"],
["汽车省油-燃油添加剂", "汽车用品-其他-其他"],
["汽车省油-省油器", "汽车用品-其他-其他"],
["汽车改装与配件-雨刮片", "汽车用品-其他-其他"],
["汽车改装与配件-灯框灯罩", "汽车用品-其他-其他"],
["汽车改装与配件-后护板", "汽车用品-其他-其他"],
["汽车改装与配件-汽车雨挡", "汽车用品-其他-其他"],
["汽车改装与配件-脚踏板", "汽车用品-其他-其他"],
["汽车改装与配件-门拉手", "汽车用品-其他-其他"],
["汽车改装与配件-汽车门碗", "汽车用品-其他-其他"],
["汽车改装与配件-油箱盖", "汽车用品-其他-其他"],
["汽车改装与配件-迎宾踏板", "汽车用品-其他-其他"],
["汽车改装与配件-尾喉消声器", "汽车用品-其他-其他"],
["汽车改装与配件-出风口", "汽车用品-其他-其他"],
["汽车改装与配件-挡泥板", "汽车用品-其他-其他"],
["汽车改装与配件-气门嘴", "汽车用品-其他-其他"],
["汽车改装与配件-扶手箱", "汽车用品-其他-其他"],
["汽车改装与配件-发动机保护板", "汽车用品-其他-其他"]
]
      BASE_URL = "http://www.guguwang.com/" 
		def belongs_to_categories
		doc.css("div.Navigation a").select{|elem| elem["href"] && elem["href"].to_s != BASE_URL}.map do |elem|
		{
			:name => elem.inner_text,
		     :url => elem["href"]
	  }
	  end
		end

    def title
      doc.css("h1.goodsname").text.strip
	end

    def price
	  doc.css("ul.goods-price span.price1").text[/\d+\.\d+/].to_f
	end

  	def stock
		  return 1 
  	end

  	def image_url
		  doc.css("div.goodspic a img").first["src"]
		end

		def desc
		  doc.css("div#goods-intro").text
		end

		def price_url

		end

		def score
		  5
		end

		def product_code
         doc.css("ul.goodsprops li:first").text.split("：")[1] 
		end

		def standard

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
    end
	end
end

