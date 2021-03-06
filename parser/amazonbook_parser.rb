# encoding: utf-8
require 'nokogiri'

module Spider
	class AmazonbookParser < Parser


    CATEGORY_MAP = [

 ["图书-文学-文学理论","图书音像-文艺-文学"],
 ["图书-文学-文学评论与鉴赏","图书音像-文艺-文学"],
 ["图书-文学-文学史","图书音像-文艺-文学"], 
 ["图书-文学-名家作品及欣赏","图书音像-文艺-文学"], 
 ["图书-文学-作品集","图书音像-文艺-文学"], 
 ["图书-文学-中国文学","图书音像-文艺-文学"], 
 ["图书-文学-外国文学","图书音像-文艺-文学"], 
 ["图书-文学-散文随笔","图书音像-文艺-文学"], 
 ["图书-文学-影视文学","图书音像-文艺-文学"], 
 ["图书-文学-诗歌词曲","图书音像-文艺-文学"], 
 ["图书-文学-纪实文学","图书音像-文艺-文学"], 
 ["图书-文学-戏剧与曲艺","图书音像-文艺-文学"], 
 ["图书-文学-民间文学","图书音像-文艺-文学"], 
 ["图书-文学-期刊杂志","图书音像-文艺-文学"], 
 ["图书-文学-文学作品导读","图书音像-文艺-文学"], 
 

 ["图书-小说-侦探/推理小说","图书音像-文艺-小说"], 
 ["图书-小说-魔幻/奇幻/玄幻小说","图书音像-文艺-小说"], 
 ["图书-小说-恐怖/惊悚小说","图书音像-文艺-小说"], 
 ["图书-小说-科幻小说","图书音像-文艺-小说"],  
 ["图书-小说-爱情小说","图书音像-文艺-爱情"],  
 ["图书-小说-青春小说","图书音像-文艺-青春"],  
 ["图书-小说-武侠小说","图书音像-文艺-小说"], 
 ["图书-小说-历史小说","图书音像-文艺-小说"], 
 ["图书-小说-官场小说","图书音像-文艺-小说"], 
 ["图书-小说-职场小说","图书音像-文艺-小说"], 
 ["图书-小说-网络小说","图书音像-文艺-小说"], 
 ["图书-小说-军旅小说","图书音像-文艺-小说"], 
 ["图书-小说-世界名著","图书音像-文艺-小说"], 
 ["图书-小说-中国古典小说","图书音像-文艺-小说"], 
 ["图书-小说-现当代小说","图书音像-文艺-小说"], 
 ["图书-小说-作品集","图书音像-文艺-小说"], 
 ["图书-小说-小说期刊杂志","图书音像-文艺-小说"], 
 

 ["图书-艺术-艺术理论与评论","图书音像-文艺-艺术"], 
 ["图书-艺术-艺术史","图书音像-文艺-艺术"], 
 ["图书-艺术-世界各国艺术概况","图书音像-文艺-艺术"], 
 ["图书-艺术-鉴赏收藏","图书音像-文艺-艺术"], 
 ["图书-艺术-绘画","图书音像-文艺-艺术"], 
 ["图书-艺术-书法","图书音像-文艺-艺术"], 
 ["图书-艺术-篆刻","图书音像-文艺-艺术"], 
 ["图书-艺术-设计","图书音像-文艺-艺术"], 
 ["图书-艺术-影视","图书音像-文艺-艺术"], 
 ["图书-艺术-动画","图书音像-文艺-艺术"], 
 ["图书-艺术-戏剧","图书音像-文艺-艺术"],
 ["图书-艺术-摄影","图书音像-文艺-摄影"], 
 ["图书-艺术-雕塑","图书音像-文艺-艺术"], 
 ["图书-艺术-建筑","图书音像-文艺-艺术"], 
 ["图书-艺术-音乐","图书音像-文艺-艺术"], 
 ["图书-艺术-舞蹈","图书音像-文艺-艺术"], 
 ["图书-艺术-工艺美术","图书音像-文艺-艺术"], 
 ["图书-艺术-传记","图书音像-文艺-传记"], 
 ["图书-艺术-艺术品拍卖","图书音像-文艺-艺术"], 
 ["图书-艺术-艺术辞典与工具书","图书音像-文艺-艺术"], 
 
 ["图书-传记-财经人物","图书音像-文艺-传记"],
 ["图书-传记-历代帝王","图书音像-文艺-传记"],
 ["图书-传记-领袖首脑","图书音像-文艺-传记"], 
 ["图书-传记-军事人物","图书音像-文艺-传记"], 
 ["图书-传记-政治人物","图书音像-文艺-传记"], 
 ["图书-传记-宗教人物","图书音像-文艺-传记"], 
 ["图书-传记-女性人物","图书音像-文艺-传记"], 
 ["图书-传记-娱乐明星","图书音像-文艺-传记"], 
 ["图书-传记-体育明星","图书音像-文艺-传记"], 
 ["图书-传记-科学家","图书音像-文艺-传记"], 
 ["图书-传记-艺术家","图书音像-文艺-传记"], 
 ["图书-传记-文学家","图书音像-文艺-传记"], 
 ["图书-传记-学者","图书音像-文艺-传记"], 
 ["图书-传记-人物合集","图书音像-文艺-传记"], 
 ["图书-传记-家族研究/谱系","图书音像-文艺-传记"], 
 ["图书-传记-参考工具书","图书音像-文艺-传记"],


 ["图书-励志与成功-成功学","图书音像-经管-励志"], 
 ["图书-励志与成功-为人处世","图书音像-经管-励志"], 
 ["图书-励志与成功-心灵读物","图书音像-经管-励志"], 
 ["图书-励志与成功-个人修养","图书音像-经管-励志"], 
 ["图书-励志与成功-个人形象","图书音像-经管-励志"], 
 ["图书-励志与成功-性格与习惯","图书音像-经管-励志"], 
 ["图书-励志与成功-思维与智力","图书音像-经管-励志"], 
 ["图书-励志与成功-情商与情绪","图书音像-经管-励志"], 
 ["图书-励志与成功-人际与社交","图书音像-经管-励志"], 
 ["图书-励志与成功-文明礼仪","图书音像-经管-励志"], 
 ["图书-励志与成功-演讲与口才","图书音像-经管-励志"], 
 ["图书-励志与成功-人在职场","图书音像-经管-励志"], 
 ["图书-励志与成功-创业必修","图书音像-经管-励志"], 
 ["图书-励志与成功-时间管理","图书音像-经管-励志"], 
 ["图书-励志与成功-销售指南","图书音像-经管-励志"], 
 ["图书-励志与成功-智慧格言","图书音像-经管-励志"], 
 ["图书-励志与成功-励志小品","图书音像-经管-励志"], 
 ["图书-励志与成功-女性励志","图书音像-经管-励志"], 
 ["图书-励志与成功-青少年励志","图书音像-经管-励志"], 
 ["图书-励志与成功-名人励志","图书音像-经管-励志"], 
 ["图书-励志与成功-大师谈励志","图书音像-经管-励志"], 
 

 ["图书-经济-经济学理论与读物","图书音像-经管-经济"],  
 ["图书-经济-经济史","图书音像-经管-经济"], 
 ["图书-经济-中国经济","图书音像-经管-经济"], 
 ["图书-经济-经济体制与改革","图书音像-经管-经济"], 
 ["图书-经济-世界经济","图书音像-经管-经济"], 
 ["图书-经济-贸易经济","图书音像-经管-经济"], 
 ["图书-经济-金融银行与货币","图书音像-经管-经济"], 
 ["图书-经济-投资理财","图书音像-经管-经济"], 
 ["图书-经济-会计","图书音像-经管-经济"], 
 ["图书-经济-审计","图书音像-经管-经济"], 
 ["图书-经济-财政税收","图书音像-经管-经济"], 
 ["图书-经济-行业经济","图书音像-经管-经济"], 
 ["图书-经济-职业资格考试","图书音像-经管-经济"], 
 ["图书-经济-财经人物","图书音像-经管-经济"], 
 ["图书-经济-法律","图书音像-经管-法律"], 
 ["图书-经济-工具书与参考书","图书音像-经管-经济"], 
 ["图书-经济-影印版及英文版","图书音像-经管-经济"], 
 

 ["图书-管理-管理学","图书音像-经管-管理"], 
 ["图书-管理-管理信息系统","图书音像-经管-管理"], 
 ["图书-管理-领导学","图书音像-经管-管理"], 
 ["图书-管理-人才学","图书音像-经管-管理"], 
 ["图书-管理-统计学","图书音像-经管-管理"], 
 ["图书-管理-谈判学","图书音像-经管-管理"], 
 ["图书-管理-战略管理","图书音像-经管-管理"], 
 ["图书-管理-财务管理","图书音像-经管-管理"], 
 ["图书-管理-人力资源管理","图书音像-经管-管理"], 
 ["图书-管理-生产与运作管理","图书音像-经管-管理"], 
 ["图书-管理-供应链管理","图书音像-经管-管理"], 
 ["图书-管理-项目管理","图书音像-经管-管理"], 
 ["图书-管理-市场营销","图书音像-经管-营销"], 
 ["图书-管理-电子商务","图书音像-经管-管理"], 
 ["图书-管理-物流管理","图书音像-经管-管理"], 
 ["图书-管理-企业经营与管理","图书音像-经管-管理"], 
 ["图书-管理-MBA与工商管理","图书音像-经管-管理"], 
 ["图书-管理-企业与企业家","图书音像-经管-管理"], 
 ["图书-管理-商务实务","图书音像-经管-管理"], 
 ["图书-管理-投资理财","图书音像-经管-投资"], 
 ["图书-管理-通俗读物","图书音像-经管-管理"], 
 ["图书-管理-管理工具书","图书音像-经管-管理"], 
 ["图书-管理-影印版及英文版","图书音像-经管-管理"], 
 
 ["图书-考试-小考","图书音像-教育-考试"], 
 ["图书-考试-会考","图书音像-教育-考试"], 
 ["图书-考试-中考","图书音像-教育-考试"], 
 ["图书-考试-高考","图书音像-教育-考试"], 
 ["图书-考试-成人高考","图书音像-教育-考试"], 
 ["图书-考试-研究生入学考试","图书音像-教育-考试"], 
 ["图书-考试-自学考试","图书音像-教育-考试"], 
 ["图书-考试-英语等级考试","图书音像-教育-考试"], 
 ["图书-考试-出国留学考试","图书音像-教育-考试"], 
 ["图书-考试-商务英语考试","图书音像-教育-考试"], 
 ["图书-考试-职称/职业英语考试","图书音像-英文原版-英语学习与考试"], 
 ["图书-考试-外语翻译资格考试","图书音像-教育-考试"], 
 ["图书-考试-小语种考试","图书音像-教育-考试"], 
 ["图书-考试-汉语类考试","图书音像-教育-考试"], 
 ["图书-考试-法律考试","图书音像-教育-考试"], 
 ["图书-考试-艺术类考试","图书音像-教育-考试"], 
 ["图书-考试-计算机考试","图书音像-教育-考试"], 
 ["图书-考试-医学类考试","图书音像-教育-考试"], 
 ["图书-考试-公务员考试","图书音像-教育-考试"], 
 ["图书-考试-资格考试/职称考试","图书音像-教育-考试"], 
 ["图书-考试-奥赛/竞赛","图书音像-教育-考试"] ,

 ["图书-计算机与互联网-计算机科学理论","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-家庭与计算机","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-办公与计算机","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-考试与认证","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-图形图像、动画、多媒体与网页开发","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-操作系统","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-程序语言与软件开发","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-数据库","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-软件工程及软件方法学","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-网络与通讯","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-计算机辅助","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-硬件/嵌入式开发","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-安全与加密","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-专用软件","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-信息系统","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-计算机控制仿真与人工智能","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-电子商务","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-IT产业与文化","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-计算机期刊杂志","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-计算机影印版","图书音像-科技-计算机/互联网"] , 
 ["图书-计算机与互联网-教材","图书音像-科技-计算机/互联网"] , 
 
 ["图书-法律-理论法学","图书音像-经管-法律"] ,  
 ["图书-法律-法律史","图书音像-经管-法律"] ,  
 ["图书-法律-国家法、宪法","图书音像-经管-法律"] ,  
 ["图书-法律-行政法","图书音像-经管-法律"] ,  
 ["图书-法律-民法","图书音像-经管-法律"] ,   
 ["图书-法律-刑法","图书音像-经管-法律"] ,   
 ["图书-法律-商法","图书音像-经管-法律"] ,  
 ["图书-法律-经济法","图书音像-经管-法律"] ,  
 ["图书-法律-诉讼法","图书音像-经管-法律"] ,  
 ["图书-法律-国际法","图书音像-经管-法律"] ,  
 ["图书-法律-网络法","图书音像-经管-法律"] ,  
 ["图书-法律-司法制度","图书音像-经管-法律"] ,  
 ["图书-法律-法律法规","图书音像-经管-法律"] ,  
 ["图书-法律-外国法律与港澳台法律","图书音像-经管-法律"] ,  
 ["图书-法律-司法案例","图书音像-经管-法律"] ,  
 ["图书-法律-司法解释","图书音像-经管-法律"] ,  
 ["图书-法律-法律工具书","图书音像-经管-法律"] ,  
 ["图书-法律-司法考试","图书音像-经管-法律"] ,  
 ["图书-法律-法律教材与法律考试","图书音像-经管-法律"] ,  
 ["图书-法律-法律文书写作","图书音像-经管-法律"] ,  
 ["图书-法律-法学文集","图书音像-经管-法律"] ,  
 ["图书-法律-法律普及读物","图书音像-经管-法律"] ,  
 ["图书-法律-法律期刊","图书音像-经管-法律"] ,  
 
 ["图书-心理学-心理学经典著作","图书音像-人文社科-心理学"] ,  
 ["图书-心理学-心理学理论","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-心理学研究方法","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-心理过程与心理状态","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-儿童心理健康","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-青少年心理健康","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-老年心理健康","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-女性心理学","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-男性心理学","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-变态/病态心理学","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-生理心理学","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-人格心理学","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-应用心理学","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-心理咨询与辅导","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-心理自助与测试","图书音像-人文社科-心理学"] ,   
 ["图书-心理学-心理学通俗读物","图书音像-人文社科-心理学"] ,   
 
 ["图书-历史-史学理论","图书音像-人文社科-历史"] , 
 ["图书-历史-世界总史","图书音像-人文社科-历史"] , 
 ["图书-历史-中国史","图书音像-人文社科-历史"] , 
 ["图书-历史-亚洲史","图书音像-人文社科-历史"] , 
 ["图书-历史-欧洲史","图书音像-人文社科-历史"] , 
 ["图书-历史-美洲史","图书音像-人文社科-历史"] , 
 ["图书-历史-非洲史","图书音像-人文社科-历史"] , 
 ["图书-历史-大洋洲史","图书音像-人文社科-历史"] , 
 ["图书-历史-地方史志","图书音像-人文社科-历史"] , 
 ["图书-历史-文化史","图书音像-人文社科-历史"] , 
 ["图书-历史-风俗习惯","图书音像-人文社科-历史"] , 
 ["图书-历史-文物考古","图书音像-人文社科-历史"] , 
 ["图书-历史-普及读物","图书音像-人文社科-历史"]  
 
 ]

    def belongs_to_categories
puts "xxxxxxxxxxxxyyyyyyyyyyyy"
product.cate_path
    end

		def title
			doc.css(".parseasinTitle").text.strip
		end

		def price
			doc.css(".priceLarge").text.strip.match(/[\d|\.]+$/)[0].to_f
		end

		def stock
			return 1
		end

		def image_url
			doc.css("#prodImageCell img")[0][:src]
		end

		def desc
		end

		def price_url
		end

		def score
		end

		def product_code
		end
		
		def standard
		end
		
		def comments
			comment_divs = doc.css('div[style="margin-left:0.5em;"]')
			(0...comment_divs.count).map do |index|
				{
					:title => doc.css('div[style="margin-left:0.5em;"] span[style="vertical-align:middle;"] b')[index].text,
					:publish_at => doc.css('div[style="margin-left:0.5em;"] span[style="vertical-align:middle;"] nobr')[index].text.gsub(/年|月/, '-').delete("日"),
					:content => doc.css('div[style="margin-left:0.5em;"]')[index].text.split("\n\n")[6]
				}
			end	
		end
		
		def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      origin_base_map(CATEGORY_MAP,route_str)
		end

		def get_union_url
      product.url+"&tag=findbest360-23"
		end
		
		def merchant
      get_merchant("卓越亚马逊")
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
        order_num_end_product.order_num.to_i
      end
		end

	end
end
