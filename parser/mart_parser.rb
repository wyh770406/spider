# encoding: utf-8
require 'nokogiri'

module Spider
  class MartParser < Parser
    CATEGORY_MAP = [ 
 ["品牌鞋城-女鞋-长筒靴", "鞋帽服饰-女鞋-靴子"],
 ["品牌鞋城-女鞋-马丁鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
 ["品牌鞋城-女鞋-短靴", "鞋帽服饰-女鞋-靴子"],
 ["品牌鞋城-女鞋-雪地靴", "鞋帽服饰-女鞋-靴子"],
 ["品牌鞋城-女鞋-平跟鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
 ["品牌鞋城-女鞋-中跟鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
 ["品牌鞋城-女鞋-高跟鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
 ["品牌鞋城-女鞋-坡跟鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
 ["品牌鞋城-女鞋-拖鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
 ["品牌鞋城-女鞋-板鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
 ["品牌鞋城-女鞋-休闲鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
 ["品牌鞋城-女鞋-凉鞋", "鞋帽服饰-女鞋-凉鞋 "],
 ["品牌鞋城-女鞋-帆布鞋", "鞋帽服饰-女鞋-帆布鞋"],
 ["品牌鞋城-运动鞋-休闲鞋", "鞋帽服饰-运动休闲鞋-休闲鞋"],
 ["品牌鞋城-运动鞋-网球鞋", "鞋帽服饰-运动休闲鞋-板鞋"],
 ["品牌鞋城-运动鞋-足球鞋", "鞋帽服饰-运动休闲鞋-足球鞋"],
 ["品牌鞋城-运动鞋-帆布鞋", "鞋帽服饰-运动休闲鞋-帆布鞋  "],
 ["品牌鞋城-运动鞋-登山鞋", "鞋帽服饰-运动休闲鞋-登山鞋"],
 ["品牌鞋城-运动鞋-跑步鞋", "鞋帽服饰-运动休闲鞋-跑步鞋"],
 ["品牌鞋城-运动鞋-篮球", "鞋帽服饰-运动休闲鞋-篮球鞋"],
 ["品牌鞋城-运动鞋-鞋板鞋", "鞋帽服饰-运动休闲鞋-板鞋"],
 ["品牌鞋城-男鞋-帆布鞋", "鞋帽服饰-男鞋-帆布鞋"],
 ["品牌鞋城-男鞋-训练鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
 ["品牌鞋城-男鞋-板鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
 ["品牌鞋城-男鞋-休闲鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
 ["品牌鞋城-男鞋-商务正装", "鞋帽服饰-男鞋-正装鞋"],
 ["品牌鞋城-男鞋-登山鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
 ["品牌鞋城-男鞋-凉鞋", "鞋帽服饰-男鞋-凉鞋"],
 ["品牌鞋城-童鞋-女童鞋", "鞋帽服饰-童鞋-其他款"],
 ["品牌鞋城-童鞋-男童鞋", "鞋帽服饰-童鞋-其他款"],
 ["手机数码-手机通讯-手机", "电脑手机数码-手机通讯-普通手机"],
 ["手机数码-数码影像-数码相机", "电脑手机数码-数码摄像-数码相机"],
 ["手机数码-数码影像-单反相机", "电脑手机数码-数码摄像-单反相机"],
 ["手机数码-数码影像-单反镜头", "电脑手机数码-数码摄像-单反镜头"],
 ["手机数码-数码影像-闪光灯/手柄", "电脑手机数码-数码摄像-闪光灯"],
 ["手机数码-3G--专区-iphone合约", "电脑手机数码-手机通讯-选号入网"],
 ["手机数码-3G--专区-预存话费送手机", "电脑手机数码-手机通讯-选号入网"],
 ["手机数码-3G--专区-无线上网卡", "电脑手机数码-电脑网络产品-无线网卡"],
 ["手机数码-3G--专区-其它", "电脑手机数码-电脑网络产品-3G网络设备"],
 ["手机数码-手机配件-蓝牙耳机", "电脑手机数码-手机配件-蓝牙耳机"],
 ["手机数码-手机配件-充电器", "电脑手机数码-手机配件-手机充电器"],
 ["手机数码-手机配件-电池", "电脑手机数码-手机配件-其它配件"],
 ["手机数码-手机配件-储存卡", "电脑手机数码-手机配件-手机存储卡"],
 ["手机数码-手机配件-其它", "电脑手机数码-手机配件-其它配件"],
 ["手机数码-数码配件-储存卡", "电脑手机数码-数码配件-存储卡"],
 ["手机数码-数码配件-电池/充电器", "电脑手机数码-数码配件-电池/充电器"],
 ["手机数码-数码配件-数码包", "电脑手机数码-数码配件-数码包"],
 ["手机数码-数码配件-摄影配件", "电脑手机数码-数码配件-三角架/云台"],
 ["手机数码-时尚影音-播放器", "电脑手机数码-时尚影音-高清播放器"],
 ["手机数码-时尚影音-播放器配件", "电脑手机数码-时尚影音-其他"],
 ["电脑办公-平板电脑-平板电脑", "电脑手机数码-电脑整机-平板电脑"],
 ["电脑办公-平板电脑-平板电脑配件", "电脑手机数码-电脑配件-CPU"],
 ["电脑办公-笔记本电脑-笔记本", "电脑手机数码-电脑整机-笔记本"],
 ["电脑办公-笔记本电脑-笔记本附件", "电脑手机数码-电脑整机-笔记本配件"],
 ["电脑办公-电脑配件-CPU主板", "电脑手机数码-电脑配件-CPU"],
 ["电脑办公-电脑配件-内存", "电脑手机数码-电脑配件-内存"],
 ["电脑办公-电脑配件-硬盘", "电脑手机数码-电脑配件-硬盘"],
 ["电脑办公-电脑配件-显卡", "电脑手机数码-电脑配件-显卡"],
 ["电脑办公-电脑配件-刻录机/光驱", "电脑手机数码-电脑配件-刻录机"],
 ["电脑办公-电脑配件-机箱", "电脑手机数码-电脑配件-机箱"],
 ["电脑办公-电脑配件-电源", "电脑手机数码-电脑配件-电源"],
 ["电脑办公-电脑配件-显示器", "电脑手机数码-电脑配件-显示器"],
 ["电脑办公-电脑配件-移动硬盘", "电脑手机数码-电脑配件-硬盘"],
 ["电脑办公-电脑配件-音箱", "电脑手机数码-时尚影音-音箱"],
 ["电脑办公-办公设备-一体机", "家电/办公-办公设备-一体机"],
 ["电脑办公-办公设备-打印机", "家电/办公-办公设备-打印机"],
 ["电脑办公-办公设备-传真机", "家电/办公-办公设备-传真机"],
 ["电脑办公-办公设备-投影机", "家电/办公-办公设备-投影仪"],
 ["电脑办公-办公设备-扫描仪", "家电/办公-办公设备-扫描仪"],
 ["家用电器-平板电视-LED电视", "家电/办公-生活家电-液晶电视"],
 ["家用电器-平板电视-液晶电视", "家电/办公-生活家电-液晶电视"],
 ["家用电器-平板电视-等离子电视", "家电/办公-生活家电-等离子电视"],
 ["家用电器-平板电视-3D电视", "家电/办公-生活家电-家庭影院"],
 ["家用电器-平板电视-其它", "家电/办公-生活家电-家庭影院"],
 ["家用电器-厨房电器-电饭煲", "家电/办公-厨房家电-电饭煲"],
 ["家用电器-厨房电器-豆浆机", "家电/办公-厨房家电-豆浆机"],
 ["家用电器-厨房电器-电压力锅/电炖锅", "家电/办公-厨房家电-电压力锅"],
 ["家用电器-厨房电器-电磁炉", "家电/办公-厨房家电-电磁炉"],
 ["家用电器-厨房电器-榨汁机", "家电/办公-厨房家电-榨汁机"],
 ["家用电器-厨房电器-微波炉", "家电/办公-厨房家电-微波炉"],
 ["家用电器-厨房电器-电水壶", "家电/办公-厨房家电-电水壶"],
 ["家用电器-厨房电器-酸奶机/煮蛋器", "家电/办公-厨房家电-酸奶机"],
 ["家用电器-生活电器-电风扇", "家电/办公-生活家电-电风扇"],
 ["家用电器-生活电器-吸尘器", "家电/办公-生活家电-吸尘器"],
 ["家用电器-生活电器-电熨斗/挂烫机", "家电/办公-小家电-熨斗"],
 ["家用电器-生活电器-干衣机", "家电/办公-小家电-其他"],
 ["家用电器-生活电器-空调扇", "家电/办公-生活家电-空调"],
 ["家用电器-生活电器-取暖器", "家电/办公-小家电-其他"],
 ["家用电器-健康护理-足浴盆/按摩器", "家电/办公-小家电-按摩器"],
 ["家用电器-健康护理-剃须刀", "家电/办公-小家电-剃须刀"],
 ["家用电器-健康护理-吹风机", "家电/办公-小家电-电吹风"],
 ["家用电器-健康护理-剃毛器", "家电/办公-小家电-脱毛器"],
 ["皮具箱包-潮流女包-手包/钱包", "箱包皮具-潮流女包-手包"],
 ["皮具箱包-潮流女包-双肩包", "箱包皮具-潮流女包-多用包"],
 ["皮具箱包-潮流女包-单肩/斜挎包", "箱包皮具-潮流女包-单肩/斜跨两用包"],
 ["皮具箱包-潮流女包-手提包", "箱包皮具-潮流女包-手提包"],
 ["皮具箱包-时尚男包-手包/钱包", "箱包皮具-时尚男包-钱包"],
 ["皮具箱包-时尚男包-手提包", "箱包皮具-时尚男包-手包"],
 ["皮具箱包-时尚男包-公文/电脑包", "箱包皮具-时尚男包-经典商务包"],
 ["皮具箱包-时尚男包-单肩斜挎包", "箱包皮具-时尚男包-斜肩包"],
 ["皮具箱包-时尚男包-双肩包", "箱包皮具-旅行箱包-双肩包"],
 ["皮具箱包-时尚男包-腰包", "箱包皮具-潮流女包-胸包"],
 ["皮具箱包-时尚男包-皮带", "鞋帽服饰-服饰配饰-领带"],
 ["皮具箱包-旅行箱包-行李/拉杆箱", "箱包皮具-旅行箱包-拉杆箱"],
 ["皮具箱包-旅行箱包-运动休闲包", "箱包皮具-旅行箱包-运动包"],
 ["家居家纺-家居服饰-内衣/内裤/家居服", "服装-内衣袜品-家居服"],
 ["家居家纺-床上用品-床品件套", "家居家纺-家纺-床品件套"],
 ["家居家纺-床上用品-毛毯被子", "家居家纺-家纺-被子"],
 ["家居家纺-床上用品-其它", "家居家纺-家纺-其他"],
 ["家居家纺-床上用品-枕芯枕套", "家居家纺-家纺-枕芯枕套"],
 ["家居家纺-家居日用-收纳储存", "家居家纺-生活日用-收纳雨具"],
 ["家居家纺-家居日用-家居陈列", "家居家纺-生活日用-创意家居"],
 ["家居家纺-家居日用-其他", "家居家纺-生活日用-健康秤"],
 ["家居家纺-家居日用-清洁用品", "家居家纺-生活日用-洗晒用品"],
 ["家居家纺-家用纺织-毛巾", "家居家纺-家纺-毛巾浴巾"],
 ["品牌眼镜-眼镜框架-女款", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜框架-通用款", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜框架-男款", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜框架-防辐射电脑镜", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-太阳眼镜-儿童款", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-太阳眼镜-通用款", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-太阳眼镜-男款", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-太阳眼镜-女款", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-功能眼镜-老花镜", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-功能眼镜-运动护目镜", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-功能眼镜-其他", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-镜片-树脂片", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-镜片-PC（抗冲击）", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-镜片-镜片", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜配件-眼镜盒", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜配件-其它", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜配件-专用螺丝刀", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜配件-镜片清洗液", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-眼镜配件-隐形眼镜伴侣盒", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-隐形眼镜-隐形护理", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-隐形眼镜-季抛", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-隐形眼镜-半年抛", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-隐形眼镜-日抛", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-隐形眼镜-月抛", "鞋帽服饰-服饰配饰-眼镜"],
 ["品牌眼镜-隐形眼镜-年抛", "鞋帽服饰-服饰配饰-眼镜"]
]
    def title
      return doc.css(".detail_goodsname h6").text if doc.css(".detail_goodsname h6").text.strip!=""
      return doc.css(".goodsname").text if doc.css(".goodsname").text.strip!=""      
    end

    def price
      return doc.css("span#today_p em").text if doc.css("span#today_p em").text.strip!=""
      return doc.css(".mart_p").text.gsub("￥","")[0,doc.css(".mart_p").text.gsub("￥","") =~ /[\u4e00-\u9fa5]/] if doc.css(".mart_p").text.strip!=""
    end

    def price_url
    end

    def stock
      return 0  if doc.css("#deliveryInfo").text =~ /无货/
      return 1  if doc.css("#deliveryInfo").text =~ /发货/  
    end

    def image_url
      #doc.css("div.imgshow img").first["src"]
     if doc.css(".smalljqzoom")
      doc.css(".smalljqzoom").first[:src] 
     end
    end

    def score
      1
    end

    def desc
    end

    def standard
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
      get_merchant("买特网")

    end

    def brand
    end

    def brand_type
    end
 
    def get_union_url
      "http://www.360mart.com/push.aspx?cpsuserguid=5698ac97389440fc900287981bd8c805&returnurl="+product.url
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
   
    # 商品代码
    def product_code
      doc.css("span.goodsnum").text.scan(/\d+/).last
    end
    
    def belongs_to_categories
      product_page_category_url = product.page.category.url
      if product_page_category_url =~ /689-/
        top_url = "http://www.360mart.com/channel/shoes.html"
        top_name = "品牌鞋城"

        if product_page_category_url.match(/689-699/)
        middle_url = "http://www.360mart.com/product/689-699.html"
        middle_name = "女鞋"
        elsif product_page_category_url.match(/689-908/)
        middle_url = "http://www.360mart.com/product/689-908.html"
        middle_name = "运动鞋"
        elsif  product_page_category_url.match(/689-437/)
        middle_url = "http://www.360mart.com/product/689-437.html"
        middle_name = "男鞋"
        elsif product_page_category_url.match(/689-701/) 
        middle_url = "http://www.360mart.com/product/689-701.html"
        middle_name = "童鞋"
        end
        [
          {
            :name => top_name,
            :url  => top_url
          },
          {
            :name => middle_name,
            :url  => middle_url
          },
          {
            :name => product.page.category.name,
            :url  => product.page.category.url
          }

        ]
      else
      doc.css(".location a").select{|elem| elem["href"] =~ /html/ &&  elem["href"] !~ /default/}.map do |elem|
        {
          :name => elem.inner_text,
          :url  => "http://www.360mart.com"+elem["href"]
        }
      end
      end
    end
    
  end
end
