# encoding: utf-8
require "nokogiri"

module Spider
  class GomeParser < Parser
    CATEGORY_MAP = [
      ["移动通讯-GSM手机", "电脑手机数码-手机通讯-普通手机"],
      ["移动通讯-CDMA手机", "电脑手机数码-手机通讯-普通手机"],
      ["移动通讯-移动3G手机", "电脑手机数码-手机通讯-智能手机"],
      ["移动通讯-联通3G手机", "电脑手机数码-手机通讯-智能手机"],
      ["移动通讯-电信3G手机", "电脑手机数码-手机通讯-智能手机"],
      ["移动通讯-双模手机", "电脑手机数码-手机通讯-智能手机"],
      ["移动通讯-对讲机", "电脑手机数码-手机通讯-对讲机"],
      ["移动通讯-有线耳机", "电脑手机数码-手机配件-手机耳机"],
      ["移动通讯-蓝牙耳机", "电脑手机数码-手机配件-蓝牙耳机"],
      ["移动通讯-手机电池", "电脑手机数码-手机配件-手机电池"],
      ["移动通讯-手机充电器", "电脑手机数码-手机配件-手机充电器"],
      ["移动通讯-移动电源", "电脑手机数码-手机配件-其它配件"],
      ["移动通讯-存储卡", "电脑手机数码-手机配件-手机存储卡"],
      ["移动通讯-读卡器", "电脑手机数码-手机配件-其它配件"],
      ["移动通讯-数据设备", "电脑手机数码-手机配件-其它配件"],
      ["移动通讯-蓝牙适配器", "电脑手机数码-手机配件-其它配件"],
      ["移动通讯-手机音响座", "电脑手机数码-手机配件-其它配件"],
      ["移动通讯-音频线/适配器", "电脑手机数码-手机配件-其它配件"],
      ["移动通讯-保护膜", "电脑手机数码-手机配件-手机贴膜"],
      ["移动通讯-手机套/外壳", "电脑手机数码-手机配件-手机保护套"],
      ["移动通讯-手机挂饰", "电脑手机数码-手机配件-手机挂件"],
      ["移动通讯-手写笔", "电脑手机数码-手机配件-其它配件"],
      ["移动通讯-无线上网卡", "电脑手机数码-电脑网络产品-无线网卡"],
      ["电脑/配件-笔记本", "电脑手机数码-电脑整机-笔记本"],
      ["电脑/配件-上网本", "电脑手机数码-电脑整机-上网本"],
      ["电脑/配件-平板电脑", "电脑手机数码-电脑整机-平板电脑"],
      ["电脑/配件-笔记本包", "电脑手机数码-电脑整机-笔记本配件"],
      ["电脑/配件-其他配件", "电脑手机数码-电脑整机-笔记本配件"],
      ["电脑/配件-台式整机", "电脑手机数码-电脑整机-台式机"],
      ["电脑/配件-台式主机", "电脑手机数码-电脑整机-台式机"],
      ["电脑/配件-一体机", "电脑手机数码-电脑整机-台式机"],
      ["电脑/配件-服务器", "电脑手机数码-电脑整机-服务器"],
      ["电脑/配件-游戏电玩", "电脑手机数码-电脑外设产品-游戏设备"],
      ["电脑/配件-游戏配件", "电脑手机数码-电脑外设产品-游戏设备"],
      ["电脑/配件-U盘", "电脑手机数码-电脑外设产品-U盘"],
      ["电脑/配件-移动硬盘", "电脑手机数码-电脑配件-硬盘"],
      ["电脑/配件-移动光驱", "电脑手机数码-电脑配件-光驱"],
      ["电脑/配件-显示器", "电脑手机数码-电脑配件-显示器"],
      ["电脑/配件-鼠标键盘", "电脑手机数码-电脑外设产品-鼠标"],
      ["电脑/配件-鼠标垫", "电脑手机数码-电脑外设产品-鼠标垫"],
      ["电脑/配件-摄像头", "电脑手机数码-电脑外设产品-摄像头"],
      ["电脑/配件-手写板", "电脑手机数码-电脑外设产品-手写板"],
      ["电脑/配件-电脑音箱", "电脑手机数码-电脑外设产品-音箱"],
      ["电脑/配件-清洁类", "电脑手机数码-电脑外设产品-电脑清洁"],
      ["电脑/配件-线缆", "电脑手机数码-电脑外设产品-线缆"],
      ["电脑/配件-路由器", "电脑手机数码-电脑网络产品-有线路由器 "],
      ["电脑/配件-网卡", "电脑手机数码-电脑网络产品-无线网卡"],
      ["电脑/配件-交换机", "电脑手机数码-电脑网络产品-交换机"],
      ["电脑/配件-HUB集线器", "电脑手机数码-电脑外设产品-其它电脑附件"],
      ["电脑/配件-网络存储", "电脑手机数码-电脑网络产品-网络存储"],
      ["电脑/配件-3G网络设备", "电脑手机数码-电脑网络产品-3G网络设备"],
      ["电脑/配件-杀毒软件", "电脑手机数码-电脑软件-杀毒软件"],
      ["电脑/配件-系统软件", "电脑手机数码-电脑软件-系统软件"],
      ["电脑/配件-办公软件", "电脑手机数码-电脑软件-办公软件"],
      ["电脑/配件-游戏软件", "电脑手机数码-电脑软件-游戏软件"],
      ["电脑/配件-CPU", "电脑手机数码-电脑配件-CPU"],
      ["电脑/配件-主板", "电脑手机数码-电脑配件-主板"],
      ["电脑/配件-显卡", "电脑手机数码-电脑配件-显卡"],
      ["电脑/配件-硬盘", "电脑手机数码-电脑配件-硬盘"],
      ["电脑/配件-内存", "电脑手机数码-电脑配件-内存"],
      ["电脑/配件-机箱", "电脑手机数码-电脑配件-机箱"],
      ["电脑/配件-电源", "电脑手机数码-电脑配件-电源"],
      ["电脑/配件-刻录机/光驱", "电脑手机数码-电脑配件-刻录机"],
      ["电脑/配件-声卡", "电脑手机数码-电脑配件-声卡"],
      ["电脑/配件-扩展卡", "电脑手机数码-电脑配件-扩展卡"],
      ["电脑/配件-散热器", "电脑手机数码-电脑配件-散热器"],
      ["OA办公-打印机", "家电/办公-办公设备-打印机"],
      ["OA办公-一体机", "家电/办公-办公设备-一体机"],
      ["OA办公-传真机", "家电/办公-办公设备-传真机"],
      ["OA办公-复印机", "家电/办公-办公设备-复印机"],
      ["OA办公-投影机及幕布", "家电/办公-办公设备-投影仪"],
      ["OA办公-扫描仪", "家电/办公-办公设备-扫描仪"],
      ["OA办公-碎纸机", "家电/办公-办公设备-碎纸机"],
      ["OA办公-考勤设备", "家电/办公-办公设备-考勤机"],
      ["OA办公-点钞机", "家电/办公-办公设备-点钞机"],
      ["OA办公-塑封设备", "家电/办公-办公设备-其他办公用品"],
      ["OA办公-电子白板", "家电/办公-办公设备-电子白板"],
      ["OA办公-装订设备", "家电/办公-办公设备-装订机"],
      ["OA办公-电话机", "家电/办公-小家电-电话"],
      ["OA办公-其他设备", "家电/办公-办公设备-其他办公用品"],
      ["OA办公-刻录光盘", "家电/办公-办公设备-刻录盘"],
      ["OA办公-光盘附件", "家电/办公-办公设备-刻录盘"],
      ["OA办公-硒鼓", "家电/办公-办公设备-硒鼓"],
      ["OA办公-墨粉", "家电/办公-办公设备-墨粉"],
      ["OA办公-墨盒", "家电/办公-办公设备-墨盒"],
      ["OA办公-色带", "家电/办公-办公设备-色带"],
      ["OA办公-计算器", "家电/办公-办公设备-办公文具"],
      ["OA办公-订书机", "家电/办公-办公设备-办公文具"],
      ["OA办公-学生文具", "家电/办公-办公设备-办公文具"],
      ["OA办公-保险箱", "家电/办公-办公设备-保险箱/柜"],
      ["相机/摄像机-数码相机", "电脑手机数码-数码摄像-数码相机"],
      ["相机/摄像机-单反相机", "电脑手机数码-数码摄像-单反相机"],
      ["相机/摄像机-单电相机", "电脑手机数码-数码摄像-单电/微单相机"],
      ["相机/摄像机-摄像机-数码摄像机", "电脑手机数码-数码摄像-数码摄像机"],
      ["相机/摄像机--照片打印机", "电脑手机数码-数码摄像-其它"],
      ["相机/摄像机-单反镜头", "电脑手机数码-数码摄像-单反镜头"],
      ["相机/摄像机-镜头附件", "电脑手机数码-数码摄像-其它"],
      ["相机/摄像机-清洁用品", "电脑手机数码-数码配件-相机清洁"],
      ["相机/摄像机-三脚架/云台", "电脑手机数码-数码配件-三角架/云台"],
      ["相机/摄像机-摄照包", "电脑手机数码-数码配件-数码包"],
      ["相机/摄像机-闪光灯/手柄", "电脑手机数码-数码摄像-闪光灯"],
      ["相机/摄像机-存储卡", "电脑手机数码-数码配件-存储卡"],
      ["相机/摄像机-读卡器", "电脑手机数码-数码配件-读卡器"],
      ["相机/摄像机-电池/充电器", "电脑手机数码-数码配件-电池/充电器"],
      ["相机/摄像机-其他配件", "电脑手机数码-数码配件-其他"],
      ["数码电子-MP3/MP4/MP5", "电脑手机数码-时尚影音-MP3/MP4"],
      ["数码电子-播放器配件", "电脑手机数码-时尚影音-高清播放器"],
      ["数码电子-高清播放器", "电脑手机数码-时尚影音-高清播放器"],
      ["数码电子-数码相框", "电脑手机数码-时尚影音-数码相框"],
      ["数码电子-耳机", "电脑手机数码-时尚影音-耳机"],
      ["数码电子-耳麦", "电脑手机数码-时尚影音-耳机"],
      ["数码电子-MID(移动互联网设备)", "电脑手机数码-时尚影音-MID移动互联网终端"],
      ["数码电子-CMMB(移动电视）", "电脑手机数码-时尚影音-高清播放器"],
      ["数码电子-电纸书", "电脑手机数码-时尚影音-电子书"],
      ["数码电子-电子词典", "电脑手机数码-时尚影音-电子词典"],
      ["数码电子-点读机", "电脑手机数码-时尚影音-点读笔/点读机"],
      ["数码电子-笔记本学习机", "电脑手机数码-时尚影音-学习机/学生电脑"],
      ["数码电子-点读笔", "电脑手机数码-时尚影音-点读笔/点读机"],
      ["数码电子-早教机", "电脑手机数码-时尚影音-其他"],
      ["数码电子-复读机", "电脑手机数码-时尚影音-复读机"],
      ["数码电子-电子书", "电脑手机数码-时尚影音-电子书"],
      ["数码电子-录音笔", "电脑手机数码-时尚影音-录音笔"],
      ["数码电子-收/录音机", "家电/办公-小家电-收录音机"],
      ["数码电子-GPS导航", "汽车用品-导航通讯-GPS导航"],
      ["数码电子-体感游戏", "电脑手机数码-时尚影音-其他"],
      ["数码电子-掌上游戏", "电脑手机数码-时尚影音-其他"],
      ["数码电子-电子玩具", "电脑手机数码-时尚影音-其他"],
      ["厨卫电器-其它电器", "家电/办公-生活家电-家电配件"],
      ["厨卫电器-面包机/多士炉", "家电/办公-厨房家电-面包机"],
      ["厨卫电器-打蛋器/煮蛋器", "家电/办公-厨房家电-煮蛋器"],
      ["厨卫电器-浴霸/换气扇", "家电/办公-小家电-浴霸"],
      ["厨卫电器-燃气热水器", "家电/办公-生活家电-热水器"],
      ["厨卫电器-电热水器", "家电/办公-生活家电-热水器"],
      ["厨卫电器-即热热水器", "家电/办公-生活家电-热水器"],
      ["厨卫电器-电动座便器", "家电/办公-生活家电-家电配件"],
      ["厨卫电器-烤饼机/电饼铛", "家居家纺-厨房用具-煎锅"],
      ["厨卫电器-电蒸锅/炖锅", "家电/办公-厨房家电-电磁炉"],
      ["厨卫电器-电压力锅", "家电/办公-厨房家电-电压力锅"],
      ["厨卫电器-电饭煲/西施煲", "家电/办公-厨房家电-电饭煲"],
      ["厨卫电器-炊具/刀具", "家居家纺-厨房用具-刀具"],
      ["厨卫电器-饮水机", "家电/办公-厨房家电-饮水机"],
      ["厨卫电器-酸奶机", "家电/办公-厨房家电-酸奶机"],
      ["厨卫电器-料理机/榨汁机", "家电/办公-厨房家电-榨汁机"],
      ["厨卫电器-咖啡壶/咖啡机", "家电/办公-厨房家电-咖啡机"],
      ["厨卫电器-净水桶", "家电/办公-厨房家电-净化器"],
      ["厨卫电器-净水机", "家电/办公-厨房家电-净化器"],
      ["厨卫电器-果蔬解毒机", "家电/办公-厨房家电-其他"],
      ["厨卫电器-豆浆机", "家电/办公-厨房家电-豆浆机"],
      ["厨卫电器-电水煲/电水壶", "家电/办公-厨房家电-电水壶"],
      ["厨卫电器-油烟机", "家电/办公-厨房家电-油烟机 "],
      ["厨卫电器-消毒柜", "家电/办公-厨房家电-消毒柜/洗碗机"],
      ["厨卫电器-洗碗机", "家电/办公-厨房家电-消毒柜/洗碗机"],
      ["厨卫电器-洗菜机", "家电/办公-厨房家电-其他"],
      ["厨卫电器-微波炉", "家电/办公-厨房家电-微波炉"],
      ["厨卫电器-水龙头", "家电/办公-厨房家电-其他"],
      ["厨卫电器-水槽", "家电/办公-厨房家电-其他"],
      ["厨卫电器-燃气灶", "家电/办公-厨房家电-燃气灶"],
      ["厨卫电器-净水设备", "家电/办公-厨房家电-其他"],
      ["厨卫电器-电烤箱/烧烤炉", "家电/办公-厨房家电-电烤箱"],
      ["厨卫电器-电磁炉", "家电/办公-厨房家电-电磁炉"],
      ["生活电器-毛球修剪器", "家居家纺-清洁用品-衣物清洁"],
      ["生活电器-挂烫机/干衣机", "家居家纺-清洁用品-衣物清洁"],
      ["生活电器-电熨斗", "家居家纺-清洁用品-衣物清洁"],
      ["生活电器-五金工具", "家居家纺-家装建材-五金工具"],
      ["生活电器-拖线插座", "家居家纺-家装建材-插座"],
      ["生活电器-收纳盒", "家居家纺-生活日用-收纳雨具"],
      ["生活电器-密封罐", "家居家纺-生活日用-收纳雨具"],
      ["生活电器-保鲜盒", "家居家纺-厨房用具-保鲜盒"],
      ["生活电器-水杯/水瓶/水壶", "家居家纺-精美餐具-水具茶具"],
      ["生活电器-灯具", "家居家纺-灯具-多用灯"],
      ["生活电器-吸尘器", "家电/办公-生活家电-吸尘器"],
      ["生活电器-清洁机", "家电/办公-小家电-清洁机"],
      ["生活电器-足浴盆", "家电/办公-生活家电-家电配件"],
      ["生活电器-剃须刀/脱毛器", "家电/办公-小家电-剃须刀"],
      ["生活电器-美容美发系列", "家电/办公-小家电-电吹风"],
      ["生活电器-口腔护理", "家电/办公-生活家电-家电配件"],
      ["生活电器-测量仪", "家电/办公-生活家电-家电配件"],
      ["生活电器-按摩保健", "家电/办公-生活家电-按摩器"],
      ["生活电器-取暖器/暖风机", "家电/办公-生活家电-家电配件"],
      ["生活电器-暖手炉/暖脚炉", "家电/办公-生活家电-家电配件"],
      ["生活电器-空调扇", "家电/办公-生活家电-家电配件"],
      ["生活电器-净化器/氧吧", "家居家纺-生活日用-净化防潮"],
      ["生活电器-加湿器/除湿机", "家电/办公-生活家电-加湿器"],
      ["生活电器-电油汀", "家电/办公-生活家电-家电配件"],
      ["生活电器-电热毯/电热袋", "家电/办公-生活家电-家电配件"],
      ["生活电器-电风扇", "家电/办公-生活家电-电风扇"],
      ["电视-LED电视", "家电/办公-生活家电-液晶电视"],

      ["电视-液晶电视", "家电/办公-生活家电-液晶电视"],
      ["电视-3D电视", "家电/办公-生活家电-家庭影院"],
      ["电视-等离子电视", "家电/办公-生活家电-等离子电视"],
      ["电视-电视挂架", "家电/办公-生活家电-家电配件"],
      ["电视-电视底座", "家电/办公-生活家电-家电配件"],
      ["电视-插线板", "家电/办公-生活家电-家电配件"],
      ["电视-遥控器", "家电/办公-生活家电-家电配件"],
      ["电视-3D电视配件", "家电/办公-生活家电-家电配件"],
      ["电视-保养配件", "家电/办公-生活家电-家电配件"],
      ["冰箱/冷柜-冰箱", "家电/办公-生活家电-冰箱"],
      ["冰箱/冷柜-冷柜", "家电/办公-厨房家电-酒柜/冷柜"],
      ["冰箱/冷柜-迷你冰箱", "家电/办公-生活家电-冰箱"],
      ["冰箱/冷柜-酒柜", "家电/办公-厨房家电-酒柜/冷柜"],
      ["冰箱/冷柜-车载冰箱", "汽车用品-汽车电器-车载冰箱"],
      ["洗衣机-波轮洗衣机", "家电/办公-生活家电-洗衣机"],
      ["洗衣机-滚筒洗衣机", "家电/办公-生活家电-洗衣机"],
      ["洗衣机-双缸洗衣机", "家电/办公-生活家电-洗衣机"],
      ["洗衣机-干衣机", "家电/办公-生活家电-洗衣机"],
      ["洗衣机-迷你洗衣机", "家电/办公-生活家电-洗衣机"],
      ["洗衣机-洗衣机配件", "家电/办公-生活家电-洗衣机"],
      ["空调-壁挂式空调", "家电/办公-生活家电-空调"],
      ["空调-柜式空调", "家电/办公-生活家电-空调"],
      ["空调-移动空调", "家电/办公-生活家电-空调"],
      ["空调-空调配件", "家电/办公-生活家电-空调"],
      ["影音家电-多媒体音响", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-便携音响", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-迷你组合音响", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-家庭影院", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-套装影院", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-音箱功放", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-CD/SACD机", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-混响器", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-普通DVD", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-移动DVD", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-蓝光DVD", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-高清播放器", "家电/办公-生活家电-音响 DVD"],
      ["影音家电-影音线材", "电脑手机数码-时尚影音-其他"],
      ["影音家电-线材转换器", "电脑手机数码-时尚影音-其他"],
      ["影音家电-麦克风", "电脑手机数码-时尚影音-其他"],
      ["影音家电-其他配件", "电脑手机数码-时尚影音-其他"],

    ]

    def title
      doc.css("#name").inner_text.strip
    end

    def price
    end

    def stock
      1
    end

    def image_url
      doc.css(".p_img_bar img").first["src"]
    end

    def desc
      #doc.css(".description").inner_html
    end

    def price_url
      doc.css("#gomeprice img").first["src"]
    end

    def score
      doc.css("#positive div.star").first["class"][/\d+/,0].to_i
    end

    def product_code
      doc.css("#sku").inner_text
    end

    def standard
      #doc.css(".Ptable").inner_html
    end

    def comments
      #http://www.gome.com.cn/appraise/getAppraise.do
      []
    end

    def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")

      origin_base_map(CATEGORY_MAP,route_str)

    end

    def merchant
      get_merchant("国美电器")
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

    def brand
    end

    def brand_type
    end

    def get_union_url
      product.url
    end

    def belongs_to_categories
      doc.css("#navigation a").select{|elem| elem["href"] && elem["href"].to_s !~ /index|brand/}.map do |elem|
        {
          :name => elem.inner_text,
          :url  => elem["href"].sub("..", "http://www.gome.com.cn")
        }
      end
    end
  end
end
