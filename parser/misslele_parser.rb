# encoding: utf-8
require 'nokogiri'

module Spider
	class MissleleParser < Parser
    BaseURL = "http://www.misslele.com/"
     CATEGORY_MAP = [
                      ["妈妈专区-孕妇服装-防辐射服", "母婴-妈妈专区-防辐射服"],
 ["妈妈专区-孕妇服装-孕妇内衣", "母婴-妈妈专区-美体装"],
 ["妈妈专区-孕妇服装-外出服装", "母婴-妈妈专区-孕妇装"],
 ["妈妈专区-妈妈食品-妈妈奶粉", "母婴-妈妈专区-孕妇奶粉"],
 ["妈妈专区-妈妈食品-保健品", "母婴-妈妈专区-恢复瘦身"],
 ["妈妈专区-妈妈用品-家居用品", "母婴-日用品-吸乳器"],
 ["妈妈专区-妈妈用品-卫生洗护", "母婴-日用品-孕婴清洁护肤"],
 ["妈妈专区-妈妈用品-哺乳用品", "母婴-日用品-吸乳器"],
 ["妈妈专区-妈妈用品-产后塑身", "母婴-妈妈专区-恢复瘦身"],
 ["妈妈专区-妈妈用品-成人尿裤", "母婴-妈妈专区-个人护理"],
 ["妈妈专区-妈妈用品-吸奶器/配件", "母婴-日用品-奶瓶奶嘴"],
 ["妈妈专区-妈妈用品-便携包袋", "母婴-日用品-背带/妈咪包"],
 ["妈妈专区-妈妈用品-婴儿背带", "母婴-日用品-背带/妈咪包"],
 ["妈妈专区-妈妈用品-胎心仪", "母婴-妈妈专区-个人护理"],
 ["婴童食品-奶粉-配方奶粉", "母婴-宝贝食品-特殊配方奶粉"],
 ["婴童食品-奶粉-羊奶粉/片", "母婴-宝贝食品-羊奶粉"],
 ["婴童食品-奶粉-特殊配方奶粉", "母婴-宝贝食品-特殊配方奶粉"],
 ["婴童食品-辅食-米粉", "母婴-宝贝食品-米粉等辅食"],
 ["婴童食品-辅食-菜粉", "母婴-宝贝食品-米粉等辅食"],
 ["婴童食品-辅食-果汁/泥", "母婴-宝贝食品-果肉泥"],
 ["婴童食品-辅食-肉松", "母婴-宝贝食品-儿童肉松"],
 ["婴童食品-辅食-饼干/磨牙棒", "母婴-宝贝食品-米粉等辅食"],
 ["婴童食品-辅食-营养面", "母婴-宝贝食品-米粉等辅食"],
 ["婴童食品-营养品-钙铁锌类", "母婴-保健营养-钙铁锌"],
 ["婴童食品-营养品-初乳粉/片", "母婴-保健营养-牛初乳类"],
 ["婴童食品-营养品-鱼肝油/糖丸", "母婴-保健营养-鱼油类"],
 ["婴童食品-营养品-营养素", "母婴-保健营养-牛初乳类"],
 ["婴童食品-营养品-益生菌类", "母婴-保健营养-DHA"],
 ["婴童食品-营养品-DHA健脑", "母婴-保健营养-DHA"],
 ["婴童食品-营养品-清火开胃", "母婴-保健营养-鱼油类"],
 ["婴童食品-营养品-果味软糖", "母婴-宝贝食品-泡芙"],
 ["婴童护理-防尿用品-婴儿尿裤/片", "母婴-日用品-纸尿裤"],
 ["婴童护理-防尿用品-婴儿尿布", "母婴-日用品-纸尿裤"],
 ["婴童护理-防尿用品-隔尿垫巾", "母婴-日用品-隔尿床垫"],
 ["婴童护理-洗护用品-婴儿湿巾", "母婴-日用品-孕婴清洁护肤"],
 ["婴童护理-洗护用品-洗漱用品", "母婴-日用品-孕婴清洁护肤"],
 ["婴童护理-洗护用品-洗浴护肤", "母婴-日用品-婴儿沐浴"],
 ["婴童护理-洗护用品-防蚊防晒", "母婴-日用品-孕婴清洁护肤"],
 ["婴童护理-洗护用品-衣物洗护", "母婴-日用品-孕婴清洁护肤"],
 ["婴童护理-日常用品-座便器", "母婴-日用品-孕婴清洁护肤"],
 ["婴童护理-日常用品-修剪器具", "母婴-日用品-孕婴清洁护肤"],
 ["婴童护理-日常用品-安全防护", "母婴-日用品-孕婴清洁护肤"],
 ["婴童护理-日常用品-用品配件", "母婴-日用品-孕婴清洁护肤"],
 ["哺喂用品-喂养用品-婴儿奶瓶", "母婴-日用品-奶瓶奶嘴"],
 ["哺喂用品-喂养用品-婴儿奶嘴", "母婴-日用品-奶瓶奶嘴"],
 ["哺喂用品-喂养用品-安抚奶嘴", "母婴-日用品-奶瓶奶嘴"],
 ["哺喂用品-喂养用品-婴儿牙胶", "母婴-日用品-孕婴清洁护肤"],
 ["哺喂用品-喂养用品-婴儿餐具", "母婴-日用品-餐具"],
 ["哺喂用品-喂养用品-杯壶用品", "母婴-日用品-餐具"],
 ["哺喂用品-喂养用品-喂养用品配件", "母婴-日用品-餐具"],
 ["哺喂用品-保温消毒-消毒器具", "母婴-日用品-孕婴清洁护肤"],
 ["哺喂用品-保温消毒-暖奶保温", "母婴-日用品-孕婴清洁护肤"],
 ["哺喂用品-保温消毒-奶瓶清洁", "母婴-日用品-孕婴清洁护肤"],
 ["哺喂用品-保温消毒-电粥锅/配件", "母婴-日用品-孕婴清洁护肤"],
 ["婴童服装-婴儿服饰-毛巾手帕/食饭衣", "母婴-童装-围嘴"],
 ["婴童服装-婴儿服饰-肚围肚兜", "母婴-童装-围嘴"],
 ["婴童服装-婴儿服饰-单衫单裤", "母婴-童装-衬衫"],
 ["婴童服装-婴儿服饰-连体服类", "母婴-童装-亲子装"],
 ["婴童服装-婴儿服饰-婴儿套装", "母婴-童装-套装"],
 ["婴童服装-婴儿服饰-套袖护膝", "母婴-童装-围嘴"],
 ["婴童服装-婴儿服饰-手套脚套", "母婴-童装-围嘴"],
 ["婴童服装-婴儿服饰-婴儿鞋袜", "母婴-童装-休闲鞋"],
 ["婴童服装-婴儿服饰-婴儿帽类", "母婴-童装-裙子"],
 ["婴童服装-婴儿服饰-婴儿礼盒", "母婴-童装-裙子"],
 ["婴童服装-儿童服饰-儿童内衣", "母婴-童装-套装"],
 ["婴童服装-儿童服饰-外出服", "母婴-童装-套装"],
 ["婴童服装-儿童服饰-儿童配饰", "母婴-童装-套装"],
 ["婴童服装-儿童服饰-儿童鞋袜", "母婴-童装-童鞋"],
 ["车床寝居-婴儿寝具-枕头被子", "家居家纺-家纺-枕芯枕套"],
 ["车床寝居-婴儿寝具-睡袋抱被", "家居家纺-家纺-其他"],
 ["车床寝居-婴儿寝具-床品套件", "家居家纺-家纺-床品件套"],
 ["车床寝居-婴儿寝具-蚊帐席子", "家居家纺-家纺-蚊帐/凉席"],
 ["车床寝居-婴童用车-手推车", "母婴-玩具-学步车"],
 ["车床寝居-婴童用车-学步车/带", "母婴-玩具-学步车"],
 ["车床寝居-婴童用车-三轮车", "母婴-玩具-学步车"],
 ["车床寝居-婴童用车-电动车", "母婴-玩具-学步车"],
 ["车床寝居-婴童用车-自行车", "母婴-玩具-学步车"],
 ["车床寝居-床椅家具-婴幼童床", "母婴-玩具-儿童家具"],
 ["车床寝居-床椅家具-安全座椅", "母婴-玩具-儿童家具"],
 ["车床寝居-床椅家具-餐桌餐椅", "母婴-玩具-儿童家具"],
 ["婴童玩具-启智玩具-模型玩偶", "母婴-玩具-模型玩具"],
 ["婴童玩具-启智玩具-遥控玩具", "母婴-玩具-遥控玩具"],
 ["婴童玩具-启智玩具-沙滩戏水", "母婴-玩具-戏水用品"],
 ["婴童玩具-启智玩具-布质毛绒", "母婴-玩具-毛绒玩具"],
 ["婴童玩具-启智玩具-木质玩具", "母婴-玩具-模型玩具"],
 ["婴童玩具-启智玩具-电动玩具", "母婴-玩具-电动玩具"],
 ["婴童玩具-启智玩具-健身玩具", "母婴-玩具-户外玩具"],
 ["婴童玩具-启智玩具-DIY/涂鸦", "母婴-玩具-益智类"],
 ["婴童玩具-启智玩具-早教益智", "母婴-玩具-益智类"],
 ["图书音像-图书-胎教图书", "母婴-益智早教-早教书籍"],
 ["图书音像-图书-育儿图书", "母婴-益智早教-早教书籍"],
 ["图书音像-图书-婴童图书", "母婴-益智早教-早教书籍"]
]
    def belongs_to_categories

      doc.css("div.site div.gray a").select{|elem| elem["href"] && elem["href"].to_s =~ /html/}.map do |elem|
        {
          :name => elem.inner_text,
          :url  => BaseURL + elem["href"]
        }
      end

    end

		def title
			doc.css(".tb_font h1").text
		end

		def price
			str = doc.css("div.tb_font span#shop_price").inner_text
			return str.to_f
		end

		def stock
			return 1
		end

		def image_url
      img_doc = doc.css("a.jqzoom")
			img = img_doc.present? ? (BaseURL + img_doc.first["href"]) : ""
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

    def get_union_url
      product.url+"?Source=65850"
		end
		
		def comments
     []	
		end
		
		def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      puts route_str
      origin_base_map(CATEGORY_MAP,route_str)
		end
		
		def merchant
      get_merchant("妙乐乐")
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
