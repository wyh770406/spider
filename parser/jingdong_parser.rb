# encoding: utf-8
require 'nokogiri'

module Spider
  class JingdongParser < Parser
    CATEGORY_MAP = [
      ["家用电器、汽车用品-大 家 电-空调","家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-大 家 电-冰箱","家电/办公-生活家电-冰箱"],
      ["家用电器、汽车用品-大 家 电-平板电视","家电/办公-生活家电-液晶电视"],
      ["家用电器、汽车用品-大 家 电-家电配件","家电/办公-生活家电-家电配件"],
      ["家用电器、汽车用品-大 家 电-热水器","家电/办公-生活家电-热水器"],
      ["家用电器、汽车用品-大 家 电-洗衣机","家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-大 家 电-烟机/灶具","家电/办公-厨房家电-燃气灶"],
      ["家用电器、汽车用品-大 家 电-消毒柜/洗碗机","家电/办公-厨房家电-消毒柜/洗碗机"],
      ["家用电器、汽车用品-大 家 电-家电下乡","家电/办公-生活家电-液晶电视"],
      ["家用电器、汽车用品-大 家 电-家庭影院","家电/办公-生活家电-家庭影院"],
      ["家用电器、汽车用品-大 家 电-迷你音响","家电/办公-生活家电-音响 DVD"],
      ["家用电器、汽车用品-大 家 电-DVD播放机","家电/办公-生活家电-音响 DVD"],
      ["家用电器、汽车用品-大 家 电-酒柜/冰吧/冷柜","家电/办公-厨房家电-酒柜/冷柜"],

      ["家用电器、汽车用品-生活电器-电风扇","家电/办公-生活家电-电风扇"],
      ["家用电器、汽车用品-生活电器-空调扇","家电/办公-生活家电-电风扇"],
      ["家用电器、汽车用品-生活电器-净化器","家电/办公-厨房家电-净化器"],
      ["家用电器、汽车用品-生活电器-饮水机","家电/办公-厨房家电-饮水机"],
      ["家用电器、汽车用品-生活电器-加湿器","家电/办公-生活家电-加湿器"],
      ["家用电器、汽车用品-生活电器-吸尘器","家电/办公-生活家电-吸尘器"],
      ["家用电器、汽车用品-生活电器-净水设备","家电/办公-厨房家电-电水壶"],
      ["家用电器、汽车用品-生活电器-挂烫机","家电/办公-小家电-熨斗"],
      ["家用电器、汽车用品-生活电器-电话机","家电/办公-小家电-电话"],
      ["家用电器、汽车用品-生活电器-插座","家电/办公-小家电-插座"],
      ["家用电器、汽车用品-生活电器-收录/音机","家电/办公-小家电-收录音机"],
      ["家用电器、汽车用品-生活电器-除湿/干衣机","家电/办公-生活家电-音响 DVD"],
      ["家用电器、汽车用品-生活电器-电熨斗","家电/办公-小家电-熨斗"],
      ["家用电器、汽车用品-生活电器-清洁机","家电/办公-小家电-清洁机"],

      ["家用电器、汽车用品-厨房电器-豆浆机","家电/办公-厨房家电-豆浆机"],
      ["家用电器、汽车用品-厨房电器-料理/榨汁机","家电/办公-厨房家电-榨汁机"],
      ["家用电器、汽车用品-厨房电器-微波炉","家电/办公-厨房家电-微波炉"],
      ["家用电器、汽车用品-厨房电器-电压力锅","家电/办公-厨房家电-电压力锅"],
      ["家用电器、汽车用品-厨房电器-电饭煲","家电/办公-厨房家电-电饭煲"],
      ["家用电器、汽车用品-厨房电器-电水壶/热水瓶","家电/办公-厨房家电-电水壶"],
      ["家用电器、汽车用品-厨房电器-电磁炉","家电/办公-厨房家电-电磁炉"],
      ["家用电器、汽车用品-厨房电器-煮蛋器","家电/办公-厨房家电-煮蛋器"],
      ["家用电器、汽车用品-厨房电器-酸奶机","家电/办公-厨房家电-酸奶机"],
      ["家用电器、汽车用品-厨房电器-面包机","家电/办公-厨房家电-面包机"],
      ["家用电器、汽车用品-厨房电器-咖啡机","家电/办公-厨房家电-咖啡机"],
      ["家用电器、汽车用品-厨房电器-电烤箱","家电/办公-厨房家电-电烤箱"],

      ["家用电器、汽车用品-个人护理-剃须刀","家电/办公-小家电-剃须刀"],
      ["家用电器、汽车用品-个人护理-剃/脱毛器","家电/办公-小家电-脱毛器"],
      ["家用电器、汽车用品-个人护理-电吹风","家电/办公-小家电-电吹风"],
      ["家用电器、汽车用品-个人护理-体温计","家电/办公-小家电-电子体温计"],
      ["家用电器、汽车用品-个人护理-按摩器","家电/办公-小家电-按摩器"],
      ["家用电器、汽车用品-个人护理-按摩椅","家电/办公-小家电-按摩椅"],

      ["家用电器、汽车用品-五金电器-电动工具","家居家纺-家装建材-五金工具"],
      ["家用电器、汽车用品-五金电器-手动工具","家居家纺-家装建材-五金工具"],
      ["家用电器、汽车用品-五金电器-浴霸/排气扇","家电/办公-小家电-浴霸"],
      ["家用电器、汽车用品-五金电器-水槽","家电/办公-小家电-五金用品"],
      ["家用电器、汽车用品-五金电器-龙头","家电/办公-小家电-五金用品"],
      ["家用电器、汽车用品-五金电器-淋浴花洒","家电/办公-小家电-五金用品"],
      ["家用电器、汽车用品-五金电器-厨卫五金","家电/办公-小家电-五金用品"],
      ["家用电器、汽车用品-五金电器-家具五金","家电/办公-小家电-五金用品"],
      ["家用电器、汽车用品-五金电器-淋浴花洒","家电/办公-小家电-五金用品"],
      ["家用电器、汽车用品-五金电器-电气开关/插座","家居家纺-家装建材-开关"],
      ["家用电器、汽车用品-五金电器-灯具","家居家纺-灯具-多用灯"],

      ["家用电器、汽车用品-汽车用品-GPS导航","汽车用品-导航通讯-GPS导航"],
      ["家用电器、汽车用品-汽车用品-电子影音","汽车用品-导航通讯-电子影音"],
      ["家用电器、汽车用品-汽车用品-美容/养护","汽车用品-养护用品-其他"],
      ["家用电器、汽车用品-汽车用品-改装/配件","汽车用品-汽车电器-其他"],
      ["家用电器、汽车用品-汽车用品-座垫/内饰","汽车用品-车内饰品-座套/座垫"],
      ["家用电器、汽车用品-汽车用品-香水/净化","汽车用品-车内用品-空气净化"],
      ["家用电器、汽车用品-汽车用品-车载电源","汽车用品-汽车电器-其他"],
      ["家用电器、汽车用品-汽车用品-车载电器","汽车用品-汽车电器-车载冰箱"],
      ["家用电器、汽车用品-汽车用品-儿童安全座椅","汽车用品-安全防盗-儿童座椅"],
      ["家用电器、汽车用品-汽车用品-冷暖箱","汽车用品-车内用品-其他"],
      ["家用电器、汽车用品-汽车用品-自驾装备","汽车用品-车内用品-自驾游用品"],
      ["家用电器、汽车用品-汽车用品-充气/吸尘","汽车用品-汽车电器-车用吸尘器"],

      ["电脑、软件、办公-电脑整机-笔记本","电脑手机数码-电脑整机-笔记本"],
      ["电脑、软件、办公-电脑整机-上网本","电脑手机数码-电脑整机-上网本"],
      ["电脑、软件、办公-电脑整机-台式机","电脑手机数码-电脑整机-台式机"],
      ["电脑、软件、办公-电脑整机-服务器","电脑手机数码-电脑整机-服务器"],
      ["电脑、软件、办公-电脑整机-平板电脑","电脑手机数码-电脑整机-平板电脑"],
      ["电脑、软件、办公-电脑整机-笔记本配件","电脑手机数码-电脑整机-笔记本配件"],

      ["电脑、软件、办公-电脑配件-CPU","电脑手机数码-电脑配件-CPU"],
      ["电脑、软件、办公-电脑配件-主板","电脑手机数码-电脑配件-主板"],
      ["电脑、软件、办公-电脑配件-显卡","电脑手机数码-电脑配件-显卡"],
      ["电脑、软件、办公-电脑配件-硬盘","电脑手机数码-电脑配件-硬盘"],
      ["电脑、软件、办公-电脑配件-内存","电脑手机数码-电脑配件-内存"],
      ["电脑、软件、办公-电脑配件-机箱","电脑手机数码-电脑配件-机箱"],
      ["电脑、软件、办公-电脑配件-电源","电脑手机数码-电脑配件-电源"],
      ["电脑、软件、办公-电脑配件-显示器","电脑手机数码-电脑配件-显示器"],
      ["电脑、软件、办公-电脑配件-刻录机/光驱","电脑手机数码-电脑配件-刻录机"],
      ["电脑、软件、办公-电脑配件-散热器","电脑手机数码-电脑配件-散热器"],
      ["电脑、软件、办公-电脑配件-声卡/扩展卡","电脑手机数码-电脑配件-声卡"],
      ["电脑、软件、办公-电脑配件-装机配件","电脑手机数码-电脑配件-装机配件"],

      ["电脑、软件、办公-外设产品-鼠标","电脑手机数码-电脑外设产品-鼠标"],
      ["电脑、软件、办公-外设产品-键盘","电脑手机数码-电脑外设产品-键盘"],
      ["电脑、软件、办公-外设产品-U盘","电脑手机数码-电脑外设产品-U盘"],
      ["电脑、软件、办公-外设产品-摄像头","电脑手机数码-电脑外设产品-摄像头"],
      ["电脑、软件、办公-外设产品-移动硬盘","电脑手机数码-电脑外设产品-移动硬盘"],
      ["电脑、软件、办公-外设产品-外置盒","电脑手机数码-电脑外设产品-外置盒"],
      ["电脑、软件、办公-外设产品-游戏设备","电脑手机数码-电脑外设产品-游戏设备"],
      ["电脑、软件、办公-外设产品-电视盒","电脑手机数码-电脑外设产品-电视盒"],
      ["电脑、软件、办公-外设产品-手写板","电脑手机数码-电脑外设产品-手写板"],
      ["电脑、软件、办公-外设产品-鼠标垫","电脑手机数码-电脑外设产品-鼠标垫"],
      ["电脑、软件、办公-外设产品-插座","电脑手机数码-电脑外设产品-插座/插线板"],
      ["电脑、软件、办公-外设产品-UPS电源","电脑手机数码-电脑外设产品-UPS电源"],
      ["电脑、软件、办公-外设产品-线缆","电脑手机数码-电脑外设产品-线缆"],
      ["电脑、软件、办公-外设产品-电脑工具","电脑手机数码-电脑外设产品-电脑工具"],
      ["电脑、软件、办公-外设产品-电脑清洁","电脑手机数码-电脑外设产品-电脑清洁"],

      ["电脑、软件、办公-网络产品-路由器","电脑手机数码-电脑网络产品-有线路由器"],
      ["电脑、软件、办公-网络产品-网卡","电脑手机数码-电脑网络产品-有线网卡"],
      ["电脑、软件、办公-网络产品-交换机","电脑手机数码-电脑网络产品-交换机"],
      ["电脑、软件、办公-网络产品-网络存储","电脑手机数码-电脑网络产品-网络存储"],
      ["电脑、软件、办公-网络产品-3G上网","电脑手机数码-电脑网络产品-3G网络设备"],

      ["电脑、软件、办公-办公打印-打印机","家电/办公-办公设备-打印机"],
      ["电脑、软件、办公-办公打印-一体机","家电/办公-办公设备-一体机"],
      ["电脑、软件、办公-办公打印-投影机","家电/办公-办公设备-投影仪"],
      ["电脑、软件、办公-办公打印-传真机","家电/办公-办公设备-传真机"],
      ["电脑、软件、办公-办公打印-复合机","家电/办公-办公设备-复合机"],
      ["电脑、软件、办公-办公打印-碎纸机","家电/办公-办公设备-碎纸机"],
      ["电脑、软件、办公-办公打印-扫描仪","家电/办公-办公设备-扫描仪"],
      ["电脑、软件、办公-办公打印-墨盒","家电/办公-办公设备-墨盒"],
      ["电脑、软件、办公-办公打印-硒鼓","家电/办公-办公设备-硒鼓"],
      ["电脑、软件、办公-办公打印-墨粉","家电/办公-办公设备-墨粉"],
      ["电脑、软件、办公-办公打印-色带","家电/办公-办公设备-色带"],

      ["电脑、软件、办公-办公文仪-计算器","家电/办公-办公设备-办公文具"],
      ["电脑、软件、办公-办公文仪-笔类","家电/办公-办公设备-办公文具"],
      ["电脑、软件、办公-办公文仪-纸类","家电/办公-办公设备-办公文具"],
      ["电脑、软件、办公-办公文仪-考勤机","家电/办公-办公设备-其他办公用品"],
      ["电脑、软件、办公-办公文仪-保险柜","家电/办公-办公设备-其他办公用品"],
      ["电脑、软件、办公-办公文仪-激光笔","家电/办公-办公设备-其他办公用品"],
      ["电脑、软件、办公-办公文仪-办公文具","家电/办公-办公设备-办公文具"],
      ["电脑、软件、办公-办公文仪-点钞机","家电/办公-办公设备-点钞机"],
      ["电脑、软件、办公-办公文仪-刻录碟片/附件","家电/办公-办公设备-办公文具"],
      ["电脑、软件、办公-办公文仪-白板/封装","家电/办公-办公设备-办公文具"],
      ["电脑、软件、办公-办公文仪-文件管理","家电/办公-办公设备-办公文具"],
      ["电脑、软件、办公-办公文仪-学生文具","家电/办公-办公设备-办公文具"],

      ["服饰鞋帽-男装-衬衫","服装-男装-衬衫"],
      ["服饰鞋帽-男装-T恤","服装-男装-T恤"],
      ["服饰鞋帽-男装-针织","服装-男装-针织"],
      ["服饰鞋帽-男装-外套","服装-男装-上衣外套"],
      ["服饰鞋帽-男装-裤子","服装-男装-裤子"],

      ["服饰鞋帽-女装-衬衫","服装-女装-衬衫"],
      ["服饰鞋帽-女装-T恤","服装-女装-T恤"],
      ["服饰鞋帽-女装-针织","服装-女装-针织衫"],
      ["服饰鞋帽-女装-外套","服装-女装-外套"],
      ["服饰鞋帽-女装-裙子","服装-女装-裙子"],
      ["服饰鞋帽-女装-裤子","服装-女装-裤子"],
      ["服饰鞋帽-女装-孕妇装","母婴-妈妈专区-孕妇装"],
      ["服饰鞋帽-女装-皮衣","服装-女装-皮衣"],

      ["服饰鞋帽-运动-运动装","服装-运动服装-运动休闲"],
      ["服饰鞋帽-运动-运动配件","服装-运动服装-运动配件"],
      ["服饰鞋帽-运动-运动鞋","鞋帽服饰-运动休闲鞋-休闲鞋"],

      ["服饰鞋帽-内衣-文胸","服装-内衣袜品-文胸"],
      ["服饰鞋帽-内衣-内裤","服装-内衣袜品-内裤"],
      ["服饰鞋帽-内衣-背心","服装-内衣袜品-背心"],
      ["服饰鞋帽-内衣-塑身","服装-内衣袜品-塑身"],
      ["服饰鞋帽-内衣-睡衣","服装-内衣袜品-睡衣"],
      ["服饰鞋帽-内衣-家居","服装-内衣袜品-家居服"],
      ["服饰鞋帽-内衣-袜子","服装-内衣袜品-袜子"],
      ["服饰鞋帽-内衣-情趣","服装-内衣袜品-情趣内衣"],

      ["服饰鞋帽-配饰-眼镜","鞋帽服饰-服饰配饰-眼镜"],
      ["服饰鞋帽-配饰-腰带","鞋帽服饰-服饰配饰-腰带"],
      ["服饰鞋帽-配饰-帽子","鞋帽服饰-服饰配饰-帽子"],
      ["服饰鞋帽-配饰-围巾","鞋帽服饰-服饰配饰-围巾"],
      ["服饰鞋帽-配饰-手套","鞋帽服饰-服饰配饰-手套"],
      ["服饰鞋帽-配饰-领带","鞋帽服饰-服饰配饰-领带"],
      ["服饰鞋帽-配饰-袖扣","鞋帽服饰-服饰配饰-袖扣"],

      ["服饰鞋帽-鞋靴-女鞋","鞋帽服饰-女鞋-正装鞋"],
      ["服饰鞋帽-鞋靴-男鞋","鞋帽服饰-男鞋-正装鞋"],
      ["服饰鞋帽-鞋靴-童鞋","鞋帽服饰-童鞋-运动鞋"],
      ["服饰鞋帽-鞋靴-拖鞋","鞋帽服饰-其他鞋-拖鞋"],

      ["服饰鞋帽-童装-男童","服装-儿童服装-男童"],
      ["服饰鞋帽-童装-女童","服装-儿童服装-女童"],
      ["服饰鞋帽-童装-宝宝服饰","服装-儿童服装-宝宝服饰"],
      ["服饰鞋帽-童装-亲子装","服装-儿童服装-亲子装"],

      ["礼品箱包、钟表首饰-奢侈品-LV","箱包皮具-奢侈品-LV"],
      ["礼品箱包、钟表首饰-奢侈品-COACH","箱包皮具-奢侈品-COACH"],
      ["礼品箱包、钟表首饰-奢侈品-PRADA","箱包皮具-奢侈品-IPRADA"],
      ["礼品箱包、钟表首饰-奢侈品-GUCCI","箱包皮具-奢侈品-GUCCI"],
      ["礼品箱包、钟表首饰-奢侈品-RIMOWA","箱包皮具-奢侈品-RIMOWA"],
      ["礼品箱包、钟表首饰-奢侈品-BALENCIAGA","箱包皮具-奢侈品-BALENCIAGA"],
      ["礼品箱包、钟表首饰-奢侈品-MIUMIU","箱包皮具-奢侈品-MIUMIU"],
      ["礼品箱包、钟表首饰-奢侈品-MARC JACOBS","箱包皮具-奢侈品-MARC JACOBS"],
      ["礼品箱包、钟表首饰-奢侈品-Ferragamo","箱包皮具-奢侈品-Salvatore Ferragamo"],
      ["礼品箱包、钟表首饰-奢侈品-DIOR","箱包皮具-奢侈品-DIOR"],
      ["礼品箱包、钟表首饰-奢侈品-BOTTEGA VENETA","箱包皮具-奢侈品-VENETA"],
      ["礼品箱包、钟表首饰-奢侈品-FENDI","箱包皮具-奢侈品-FENDI"],
      ["礼品箱包、钟表首饰-奢侈品-BURBERRY","箱包皮具-奢侈品-BURBERRY"],

      ["礼品箱包、钟表首饰-潮流女包-钱包/手包","箱包皮具-潮流女包-钱包"],
      ["礼品箱包、钟表首饰-潮流女包-手提/斜挎包","箱包皮具-潮流女包-手提/斜挎两用包"],
      ["礼品箱包、钟表首饰-潮流女包-多用包","箱包皮具-潮流女包-多用包"],
      ["礼品箱包、钟表首饰-潮流女包-帆布包","箱包皮具-潮流女包-帆布包"],
      ["礼品箱包、钟表首饰-潮流女包-化妆包","箱包皮具-潮流女包-化妆包"],
      ["礼品箱包、钟表首饰-潮流女包-妈咪/学生包","箱包皮具-潮流女包-妈咪/学生包"],

      ["礼品箱包、钟表首饰-时尚男包-钱包/手包","箱包皮具-时尚男包-钱包"],
      ["礼品箱包、钟表首饰-时尚男包-户外登山包","箱包皮具-时尚男包-户外登山包"],
      ["礼品箱包、钟表首饰-时尚男包-商务公文包","箱包皮具-时尚男包-经典商务包"],
      ["礼品箱包、钟表首饰-时尚男包-电脑数码包","箱包皮具-时尚男包-电脑数码包"],

      ["礼品箱包、钟表首饰-旅行箱包-运动包","箱包皮具-旅行箱包-运动包"],
      ["礼品箱包、钟表首饰-旅行箱包-休闲包","箱包皮具-旅行箱包-休闲包"],
      ["礼品箱包、钟表首饰-旅行箱包-旅行包","箱包皮具-旅行箱包-旅行包"],
      ["礼品箱包、钟表首饰-旅行箱包-拉杆箱","箱包皮具-旅行箱包-拉杆箱"],

      ["礼品箱包、钟表首饰-礼品-火机烟具","其他-礼品/礼物-火机烟具"],
      ["礼品箱包、钟表首饰-礼品-高档笔具","其他-礼品/礼物-高档笔具"],
      ["礼品箱包、钟表首饰-礼品-瑞士军刀","其他-礼品/礼物-瑞士军刀"],
      ["礼品箱包、钟表首饰-礼品-金银藏品","其他-礼品/礼物-金银藏品"],
      ["礼品箱包、钟表首饰-礼品-鲜花速递","其他-礼品/礼物-鲜花快递"],
      ["礼品箱包、钟表首饰-礼品-礼品礼券","其他-礼品/礼物-礼品礼券"],
      ["礼品箱包、钟表首饰-礼品-工艺摆件","其他-礼品/礼物-工艺摆件"],
      ["礼品箱包、钟表首饰-礼品-婚庆用品","其他-礼品/礼物-婚庆用品"],

      ["礼品箱包、钟表首饰-钟表-瑞士品牌","珠宝配饰-手表钟表-瑞士名表"],
      ["礼品箱包、钟表首饰-钟表-日本品牌","珠宝配饰-手表钟表-日本名表"],
      ["礼品箱包、钟表首饰-钟表-国产品牌","珠宝配饰-手表钟表-国产名表"],
      ["礼品箱包、钟表首饰-钟表-时尚品牌","珠宝配饰-手表钟表-时尚品牌"],
      ["礼品箱包、钟表首饰-钟表-儿童手表","珠宝配饰-手表钟表-儿童手表"],
      ["礼品箱包、钟表首饰-钟表-闹钟挂钟","珠宝配饰-手表钟表-挂钟/闹钟"],

      ["礼品箱包、钟表首饰-珠宝首饰-钻石饰品","珠宝配饰-钻石珠宝-钻石饰品"],
      ["礼品箱包、钟表首饰-珠宝首饰-黄金铂金","珠宝配饰-金银首饰-黄金铂金"],
      ["礼品箱包、钟表首饰-珠宝首饰-k金饰品","珠宝配饰-金银首饰-k金饰品"],
      ["礼品箱包、钟表首饰-珠宝首饰-翡翠玉石","珠宝配饰-翡翠琥珀-翡翠玉石"],
      ["礼品箱包、钟表首饰-珠宝首饰-纯银饰品","珠宝配饰-金银首饰-纯银饰品"],
      ["礼品箱包、钟表首饰-珠宝首饰-水晶饰品","珠宝配饰-翡翠琥珀-水晶饰品"],
      ["礼品箱包、钟表首饰-珠宝首饰-珍珠饰品","珠宝配饰-钻石珠宝-珍珠饰品"],

      ["母婴、玩具、乐器-奶粉-特殊配方","母婴-宝贝食品-特殊配方奶粉"],
      ["母婴、玩具、乐器-奶粉-孕妇奶粉","母婴-妈妈专区-孕妇奶粉"],
      ["母婴、玩具、乐器-奶粉-1段","母婴-宝贝食品-一段奶粉"],
      ["母婴、玩具、乐器-奶粉-2段","母婴-宝贝食品-二段奶粉"],
      ["母婴、玩具、乐器-奶粉-3段","母婴-宝贝食品-三段奶粉"],
      ["母婴、玩具、乐器-奶粉-4段","母婴-宝贝食品-四段奶粉"],

      ["母婴、玩具、乐器-营养辅食-米粉/菜粉","母婴-宝贝食品-泡芙"],
      ["母婴、玩具、乐器-营养辅食-果泥/果汁","母婴-宝贝食品-果肉泥"],
      ["母婴、玩具、乐器-营养辅食-肉松/饼干","母婴-宝贝食品-儿童肉松"],
      ["母婴、玩具、乐器-营养辅食-辅食","母婴-宝贝食品-果肉泥"],
      ["母婴、玩具、乐器-营养辅食-初乳","母婴-宝贝食品-果肉泥"],
      ["母婴、玩具、乐器-营养辅食-维生素","母婴-宝贝食品-果肉泥"],

      ["母婴、玩具、乐器-尿裤湿巾-新生儿","母婴-日用品-纸尿裤"],
      ["母婴、玩具、乐器-尿裤湿巾-S号","母婴-日用品-纸尿裤"],
      ["母婴、玩具、乐器-尿裤湿巾-M号","母婴-日用品-纸尿裤"],
      ["母婴、玩具、乐器-尿裤湿巾-L号","母婴-日用品-纸尿裤"],
      ["母婴、玩具、乐器-尿裤湿巾-XL号","母婴-日用品-纸尿裤"],
      ["母婴、玩具、乐器-尿裤湿巾-成长裤","母婴-日用品-纸尿裤"],
      ["母婴、玩具、乐器-尿裤湿巾-布尿裤/尿垫","母婴-日用品-隔尿床垫"],

      ["母婴、玩具、乐器-喂养用品-奶瓶/奶嘴","母婴-日用品-奶瓶奶嘴"],
      ["母婴、玩具、乐器-喂养用品-吸奶器","母婴-日用品-吸乳器"],
      ["母婴、玩具、乐器-喂养用品-餐具饮具","母婴-日用品-餐具"],

      ["母婴、玩具、乐器-洗护用品-洗发沐浴","母婴-日用品-婴儿沐浴"],
      ["母婴、玩具、乐器-洗护用品-护肤用品","母婴-日用品-孕婴清洁护肤"],
      ["母婴、玩具、乐器-洗护用品-衣物清洁","母婴-日用品-孕婴清洁护肤"],
      ["母婴、玩具、乐器-洗护用品-用品清洁","母婴-日用品-孕婴清洁护肤"],

      ["母婴、玩具、乐器-童车童床-婴儿推车","母婴-日用品-婴儿车"],
      ["母婴、玩具、乐器-童车童床-婴儿床","母婴-日用品-婴儿床"],
      ["母婴、玩具、乐器-童车童床-儿童床品","家居家纺-家纺-床品件套"],
      ["母婴、玩具、乐器-童车童床-学步车","母婴-玩具-学步车"],
      ["母婴、玩具、乐器-童车童床-电动车","母婴-玩具-电动玩具"],

      ["母婴、玩具、乐器-玩具乐器-益智玩具","母婴-玩具-益智类"],
      ["母婴、玩具、乐器-玩具乐器-毛绒布艺","母婴-玩具-毛绒玩具"],
      ["母婴、玩具、乐器-玩具乐器-动漫人物","母婴-玩具-动漫玩具"],
      ["母婴、玩具、乐器-玩具乐器-遥控玩具","母婴-玩具-遥控玩具"],
      ["母婴、玩具、乐器-玩具乐器-音乐玩具","母婴-玩具-音乐玩具"],
      ["母婴、玩具、乐器-玩具乐器-模型","母婴-玩具-模型玩具"],

      ["母婴、玩具、乐器-孕妇用品-孕妇服/内衣","母婴-妈妈专区-孕妇装"],
      ["母婴、玩具、乐器-孕妇用品-防辐射服","母婴-妈妈专区-防辐射服"],
      ["母婴、玩具、乐器-孕妇用品-产后塑身","服装-内衣袜品-塑身"],
      ["母婴、玩具、乐器-孕妇用品-妈咪包/背婴带","母婴-日用品-背带/妈咪包"],

      ["手机数码-手机通讯-手机","电脑手机数码-手机通讯-普通手机"],
      ["手机数码-手机通讯-对讲机","电脑手机数码-手机通讯-对讲机"],
      ["手机数码-手机通讯-选号入网","电脑手机数码-手机通讯-选号入网"],

      ["手机数码-手机配件-手机电池","电脑手机数码-手机配件-手机电池"],
      ["手机数码-手机配件-蓝牙耳机","电脑手机数码-手机配件-蓝牙耳机"],
      ["手机数码-手机配件-手机充电器","电脑手机数码-手机配件-手机充电器"],
      ["手机数码-手机配件-手机耳机","电脑手机数码-手机配件-手机耳机"],
      ["手机数码-手机配件-手机贴膜","电脑手机数码-手机配件-手机贴膜"],
      ["手机数码-手机配件-手机存储卡","电脑手机数码-手机配件-手机存储卡"],
      ["手机数码-手机配件-手机保护套","电脑手机数码-手机配件-手机保护套"],
      ["手机数码-手机配件-车载配件","电脑手机数码-手机配件-车载手机配件"],
      ["手机数码-手机配件-iPhone 配件","电脑手机数码-手机配件-苹果专用配件"],
      ["手机数码-手机配件-其它配件","电脑手机数码-手机配件-其它配件"],

      ["手机数码-摄影摄像-数码相机","电脑手机数码-数码摄像-数码摄像机"],
      ["手机数码-摄影摄像-单电/微单相机","电脑手机数码-数码摄像-单电/微单相机"],
      ["手机数码-摄影摄像-单反相机","电脑手机数码-数码摄像-单反相机"],
      ["手机数码-摄影摄像-摄像机","电脑手机数码-数码摄像-数码摄像机"],
      ["手机数码-摄影摄像-单反镜头","电脑手机数码-数码摄像-单反镜头"],
      ["手机数码-摄影摄像-滤镜","电脑手机数码-数码摄像-滤镜"],
      ["手机数码-摄影摄像-闪光灯/手柄","电脑手机数码-数码摄像-闪光灯"],
      ["手机数码-摄影摄像-单反配件","电脑手机数码-数码摄像-单反配件"],

      ["手机数码-数码配件-存储卡","电脑手机数码-数码配件-存储卡"],
      ["手机数码-数码配件-电池/充电器","电脑手机数码-数码配件-电池/充电器"],
      ["手机数码-数码配件-读卡器","电脑手机数码-数码配件-读卡器"],
      ["手机数码-数码配件-移动电源","电脑手机数码-数码配件-移动电源"],
      ["手机数码-数码配件-数码包","电脑手机数码-数码配件-数码包"],
      ["手机数码-数码配件-数码贴膜","电脑手机数码-数码配件-数码贴膜"],
      ["手机数码-数码配件-三脚架/云台","电脑手机数码-数码配件-三角架/云台"],
      ["手机数码-数码配件-相机清洁","电脑手机数码-数码配件-相机清洁"],

      ["手机数码-时尚影音-MP3/MP4","电脑手机数码-时尚影音-MP3/MP4"],
      ["手机数码-时尚影音-MID","电脑手机数码-时尚影音-MID移动互联网终端"],
      ["手机数码-时尚影音-耳机","电脑手机数码-时尚影音-耳机"],
      ["手机数码-时尚影音-音箱","电脑手机数码-时尚影音-音箱"],
      ["手机数码-时尚影音-高清播放器","电脑手机数码-时尚影音-高清播放器"],
      ["手机数码-时尚影音-电子书","电脑手机数码-时尚影音-电子书"],
      ["手机数码-时尚影音-电子词典","电脑手机数码-时尚影音-电子词典"],
      ["手机数码-时尚影音-MP3/MP4配件","电脑手机数码-时尚影音-MP3/MP4配件"],
      ["手机数码-时尚影音-录音笔","电脑手机数码-时尚影音-录音笔"],
      ["手机数码-时尚影音-麦克风","电脑手机数码-电脑外设产品-麦克风"],
      ["手机数码-时尚影音-电子教育","电脑手机数码-时尚影音-学习机/学生电脑"],
      ["手机数码-时尚影音-数码相框","电脑手机数码-时尚影音-数码相框"],

      ["家居、厨具、家装-厨房用具-炒锅","家居家纺-厨房用具-炒锅"],
      ["家居、厨具、家装-厨房用具-汤锅","家居家纺-厨房用具-汤锅"],
      ["家居、厨具、家装-厨房用具-压力锅","家居家纺-厨房用具-压力锅"],
      ["家居、厨具、家装-厨房用具-蒸锅","家居家纺-厨房用具-蒸锅"],
      ["家居、厨具、家装-厨房用具-煎锅","家居家纺-厨房用具-煎锅"],
      ["家居、厨具、家装-厨房用具-奶锅","家居家纺-厨房用具-奶锅"],
      ["家居、厨具、家装-厨房用具-套锅","家居家纺-厨房用具-套锅"],
      ["家居、厨具、家装-厨房用具-水壶","家居家纺-厨房用具-水壶"],
      ["家居、厨具、家装-厨房用具-刀具","家居家纺-厨房用具-刀具"],
      ["家居、厨具、家装-厨房用具-保鲜盒","家居家纺-厨房用具-保鲜盒"],
      ["家居、厨具、家装-厨房用具-厨具用品","家居家纺-厨房用具-厨具用品"],
      ["家居、厨具、家装-厨房用具-厨用小件","家居家纺-厨房用具-厨用小件"],

      ["家居、厨具、家装-精美餐具-筷勺/刀叉","家居家纺-精美餐具-筷勺/刀叉"],
      ["家居、厨具、家装-精美餐具-酒具/杯具","家居家纺-精美餐具-酒具/杯具"],
      ["家居、厨具、家装-精美餐具-水具","家居家纺-精美餐具-水具茶具"],
      ["家居、厨具、家装-精美餐具-茶具/咖啡具","家居家纺-精美餐具-咖啡具"],
      ["家居、厨具、家装-精美餐具-美食工具","家居家纺-精美餐具-套装美食工具"],
      ["家居、厨具、家装-精美餐具-组合套装","家居家纺-精美餐具-套装美食工具"],
      ["家居、厨具、家装-精美餐具-碗碟","家居家纺-精美餐具-碗碟"],

      ["家居、厨具、家装-家纺-床品件套","家居家纺-家纺-床品件套"],
      ["家居、厨具、家装-家纺-被子","家居家纺-家纺-被子"],
      ["家居、厨具、家装-家纺-枕芯枕套","家居家纺-家纺-枕芯枕套"],
      ["家居、厨具、家装-家纺-床单被罩","家居家纺-家纺-床单/被罩"],
      ["家居、厨具、家装-家纺-毛巾被/毯","家居家纺-家纺-毛巾被"],
      ["家居、厨具、家装-家纺-床垫","家居家纺-家纺-毯子/床垫"],
      ["家居、厨具、家装-家纺-蚊帐/凉席","家居家纺-家纺-蚊帐/凉席"],
      ["家居、厨具、家装-家纺-抱枕坐垫","家居家纺-家纺-抱枕坐垫"],
      ["家居、厨具、家装-家纺-毛巾家纺","家居家纺-家纺-毛巾浴巾"],
      ["家居、厨具、家装-家纺-罩/垫/套","家居家纺-家纺-罩/垫/套"],

      ["家居、厨具、家装-家具-大家具","家居家纺-家具-大家具"],
      ["家居、厨具、家装-家具-书架/CD架","家居家纺-家具-书架/CD架"],
      ["家居、厨具、家装-家具-金属层架","家居家纺-家具-金属层架"],
      ["家居、厨具、家装-家具-木质层架","家居家纺-家具-木质层架"],
      ["家居、厨具、家装-家具-衣柜/衣架","家居家纺-家具-衣柜/衣架"],
      ["家居、厨具、家装-家具-鞋架/鞋柜","家居家纺-家具-鞋架/鞋柜"],
      ["家居、厨具、家装-家具-电视柜/储物柜","家居家纺-家具-电视柜/储物柜"],
      ["家居、厨具、家装-家具-边桌/茶几","家居家纺-家具-边桌/茶几"],
      ["家居、厨具、家装-家具-休闲椅/凳","家居家纺-家具-休闲椅/凳"],
      ["家居、厨具、家装-家具-晒衣架/烫衣板","家居家纺-家具-晒衣架/烫衣板"],
      ["家居、厨具、家装-家具-儿童家具","家居家纺-家具-儿童家具"],

      ["家居、厨具、家装-灯具-台灯","家居家纺-灯具-台灯"],
      ["家居、厨具、家装-灯具-节能灯","家居家纺-灯具-节能灯"],
      ["家居、厨具、家装-灯具-装饰灯","家居家纺-灯具-装饰灯"],
      ["家居、厨具、家装-灯具-多用灯","家居家纺-灯具-多用灯"],
      ["家居、厨具、家装-灯具-吸顶灯","家居家纺-灯具-吸顶灯"],
      ["家居、厨具、家装-灯具-LED灯","家居家纺-灯具-LED 灯"],
      ["家居、厨具、家装-灯具-手电","家居家纺-灯具-手电"],

      ["家居、厨具、家装-生活日用-收纳用品","家居家纺-生活日用-收纳雨具"],
      ["家居、厨具、家装-生活日用-雨伞雨具","家居家纺-生活日用-收纳雨具"],
      ["家居、厨具、家装-生活日用-浴室用品","家居家纺-生活日用-浴室用品"],
      ["家居、厨具、家装-生活日用-缝纫用品","家居家纺-生活日用-缝纫用品"],
      ["家居、厨具、家装-生活日用-家装软饰","家居家纺-生活日用-家装软饰"],
      ["家居、厨具、家装-生活日用-洗晒用品","家居家纺-生活日用-洗晒用品"],
      ["家居、厨具、家装-生活日用-炭净化","家居家纺-生活日用-炭净化"],

      ["家居、厨具、家装-清洁用品-衣物清洁","家居家纺-清洁用品-衣物清洁"],
      ["家居、厨具、家装-清洁用品-居室清洁","家居家纺-清洁用品-居室清洁"],
      ["家居、厨具、家装-清洁用品-厨房清洁","家居家纺-清洁用品-厨房清洁"],
      ["家居、厨具、家装-清洁用品-卫浴清洁","家居家纺-清洁用品-卫浴清洁"],
      ["家居、厨具、家装-清洁用品-扫把/拖把","家居家纺-清洁用品-扫把/拖把"],
      ["家居、厨具、家装-清洁用品-清洁工具","家居家纺-清洁用品-清洁工具"],
      ["家居、厨具、家装-清洁用品-垃圾桶/垃圾袋","家居家纺-清洁用品-垃圾桶/垃圾袋"],
      ["家居、厨具、家装-清洁用品-驱虫用品","家居家纺-清洁用品-驱虫用品"],
      ["家居、厨具、家装-清洁用品-皮具护理","家居家纺-清洁用品-皮具护理"],
      ["家居、厨具、家装-清洁用品-纸品","家居家纺-清洁用品-纸品"],

      ["家居、厨具、家装-宠物用品-主食","家居家纺-宠物用品-主食零食"],
      ["家居、厨具、家装-宠物用品-零食","家居家纺-宠物用品-主食零食"],
      ["家居、厨具、家装-宠物用品-洗护用品","家居家纺-宠物用品-洗护用品"],
      ["家居、厨具、家装-宠物用品-宠物保健品","家居家纺-宠物用品-宠物保健品"],
      ["家居、厨具、家装-宠物用品-玩具","家居家纺-宠物用品-日用品玩具"],
      ["家居、厨具、家装-宠物用品-日用品","家居家纺-生活日用-日用品玩具"],

      ["家居、厨具、家装-家装建材-瓷砖","家居家纺-家装建材-瓷砖地板"],
      ["家居、厨具、家装-家装建材-地板","家居家纺-家装建材-瓷砖地板"],
      ["家居、厨具、家装-家装建材-厨卫","家居家纺-家装建材-厨卫"],
      ["家居、厨具、家装-家装建材-门窗","家居家纺-家装建材-门窗"],
      ["家居、厨具、家装-家装建材-油漆/壁纸","家居家纺-家装建材-油漆/壁纸"],
      ["家居、厨具、家装-家装建材-五金工具","家居家纺-家装建材-五金工具"],

      ["个护化妆-面部护理-洁面乳","美容护肤-日常护肤-洁面"],
      ["个护化妆-面部护理-爽肤水","美容护肤-日常护肤-护肤水"],
      ["个护化妆-面部护理-乳液面霜","美容护肤-日常护肤-乳液"],
      ["个护化妆-面部护理-面膜面贴","美容护肤-日常护肤-面膜"],
      ["个护化妆-面部护理-眼部护理","美容护肤-日常护肤-眼部"],
      ["个护化妆-面部护理-颈部护理","美容护肤-日常护肤-其他"],
      ["个护化妆-面部护理-T区护理","美容护肤-日常护肤-其他"],
      ["个护化妆-面部护理-护肤套装","美容护肤-日常护肤-其他"],

      ["个护化妆-身体护理-洗发","美容护肤-身体护理-洗发护发"],
      ["个护化妆-身体护理-护发","美容护肤-身体护理-洗发护发"],
      ["个护化妆-身体护理-沐浴","美容护肤-身体护理-沐浴"],
      ["个护化妆-身体护理-造型","美容护肤-身体护理-其他"],
      ["个护化妆-身体护理-染发","美容护肤-身体护理-其他"],
      ["个护化妆-身体护理-香皂","美容护肤-身体护理-其他"],

      ["个护化妆-口腔护理-牙膏/牙粉","美容护肤-身体护理-口腔手足"],
      ["个护化妆-口腔护理-牙刷/牙线","美容护肤-身体护理-口腔手足"],
      ["个护化妆-口腔护理-漱口水","美容护肤-身体护理-口腔手足"],

      ["个护化妆-女性护理-卫生巾","美容护肤-身体护理-其他"],
      ["个护化妆-女性护理-卫生护垫","美容护肤-身体护理-其他"],
      ["个护化妆-女性护理-洗液","美容护肤-身体护理-其他"],

      ["个护化妆-男士护理-脸部护理","美容护肤-身体护理-其他"],
      ["个护化妆-男士护理-眼部护理","美容护肤-身体护理-其他"],
      ["个护化妆-男士护理-身体护理","美容护肤-身体护理-其他"],
      ["个护化妆-男士护理-男士香水","美容护肤-身体护理-其他"],
      ["个护化妆-男士护理-剃须护理","美容护肤-身体护理-其他"],

      ["个护化妆-魅力彩妆-防晒隔离","美容护肤-魅力彩妆-防晒霜"],
      ["个护化妆-魅力彩妆-粉底/遮瑕","美容护肤-魅力彩妆-遮瑕膏"],
      ["个护化妆-魅力彩妆-腮红","美容护肤-魅力彩妆-腮红胭脂"],
      ["个护化妆-魅力彩妆-眼影/眼线","美容护肤-魅力彩妆-眼影"],
      ["个护化妆-魅力彩妆-睫毛膏","美容护肤-魅力彩妆-睫毛膏"],
      ["个护化妆-魅力彩妆-唇膏唇彩","美容护肤-魅力彩妆-眼唇妆"],
      ["个护化妆-魅力彩妆-卸妆","美容护肤-魅力彩妆-卸妆乳"],
      ["个护化妆-魅力彩妆-彩妆工具","美容护肤-魅力彩妆-美容工具"],

      ["个护化妆-香水SPA-女士香水","美容护肤-身体护理-其他"],
      ["个护化妆-香水SPA-男士香水","美容护肤-身体护理-其他"],
      ["个护化妆-香水SPA-组合套装","美容护肤-身体护理-其他"],
      ["个护化妆-香水SPA-香薰精油","美容护肤-身体护理-其他"],

      ["运动健康-户外鞋服-户外服装","运动户外-运动名品-运动服装"],
      ["运动健康-户外鞋服-户外配饰","运动户外-运动名品-运动鞋"],
      ["运动健康-户外鞋服-户外鞋袜","运动户外-运动名品-运动鞋"],

      ["运动健康-户外装备-帐篷","运动户外-户外装备-帐篷"],
      ["运动健康-户外装备-睡袋","运动户外-户外装备-睡袋"],
      ["运动健康-户外装备-登山攀岩","运动户外-户外装备-登山攀岩"],
      ["运动健康-户外装备-户外背包","运动户外-户外装备-户外背包"],
      ["运动健康-户外装备-户外照明","运动户外-户外装备-户外照明"],
      ["运动健康-户外装备-户外垫子","运动户外-户外装备-户外垫子"],
      ["运动健康-户外装备-户外仪表","运动户外-户外装备-指南针等户外仪表"],
      ["运动健康-户外装备-户外工具","运动户外-户外装备-刀具/工具"],
      ["运动健康-户外装备-望远镜","运动户外-户外装备-望远镜"],
      ["运动健康-户外装备-垂钓用品","运动户外-户外装备-垂钓用品"],
      ["运动健康-户外装备-旅游用品","运动户外-户外装备-旅游用品"],
      ["运动健康-户外装备-泳衣","运动户外-户外装备-泳衣"],
      ["运动健康-户外装备-泳镜/泳帽","运动户外-户外装备-泳镜/泳帽"],
      ["运动健康-户外装备-泳圈玩具","运动户外-户外装备-泳圈玩具"],
      ["运动健康-户外装备-便携桌椅床","运动户外-户外装备-便携桌椅床"],
      ["运动健康-户外装备-烧烤用品","运动户外-户外装备-烧烤用品"],
      ["运动健康-户外装备-野餐炊具","运动户外-户外装备-野餐炊具"],

      ["运动健康-运动器械-健身器械","运动户外-运动器械-健身器械"],
      ["运动健康-运动器械-极限运动","运动户外-运动器械-极限运动"],
      ["运动健康-运动器械-自行车及配件","运动户外-户外装备-自行车"],

      ["运动健康-体育娱乐-篮球用品","运动户外-运动名品-篮球用品"],
      ["运动健康-体育娱乐-足球用品","运动户外-运动名品-足球用品"],
      ["运动健康-体育娱乐-网球用品","运动户外-运动名品-网球用品"],

      ["运动健康-纤体瑜伽-瑜伽垫","运动户外-运动名品-瑜珈用品"],
      ["运动健康-纤体瑜伽-瑜伽服","运动户外-运动名品-瑜珈用品"],
      ["运动健康-纤体瑜伽-瑜伽配件","运动户外-运动名品-瑜珈用品"],
      ["运动健康-纤体瑜伽-瑜伽套装","运动户外-运动名品-瑜珈用品"],

      ["运动健康-保健器械-养生器械","运动户外-运动名品-康体保健"],
      ["运动健康-保健器械-保健用品","运动户外-运动名品-康体保健"],
      ["运动健康-保健器械-康复辅助","运动户外-运动名品-康体保健"],

      ["运动健康-急救卫生-跌打损伤","药品-日常用药-跌打损伤"],
      ["运动健康-急救卫生-风湿骨痛","药品-日常用药-风湿痛风"],
      ["运动健康-急救卫生-口腔咽部","药品-日常用药-清咽含片"],
      ["运动健康-急救卫生-鼻炎健康","药品-日常用药-五官用药"],

      ["食品饮料、保健品-地方特产-华北","食品/保健品-地方特产-北京"],
      ["食品饮料、保健品-地方特产-华东","食品/保健品-地方特产-上海"],
      ["食品饮料、保健品-地方特产-华南","食品/保健品-地方特产-广东"],

      ["食品饮料、保健品-休闲食品-蜜饯果脯","食品/保健品-休闲零食-蜜饯"],
      ["食品饮料、保健品-休闲食品-肉干肉松","食品/保健品-休闲零食-牛肉干"],
      ["食品饮料、保健品-休闲食品-坚果炒货","食品/保健品-休闲零食-坚果炒货"],
      ["食品饮料、保健品-休闲食品-糖果/巧克力","食品/保健品-休闲零食-巧克力"],
      ["食品饮料、保健品-休闲食品-饼干蛋糕","食品/保健品-休闲零食-蛋糕"],


      ["食品饮料、保健品-粮油调味-米面杂粮","食品/保健品-粮油生鲜-粗粮"],
      ["食品饮料、保健品-粮油调味-食用油","食品/保健品-粮油生鲜-食用油"],
      ["食品饮料、保健品-粮油调味-有机食品","食品/保健品-粮油生鲜-有机食品"],
      ["食品饮料、保健品-粮油调味-调味品","食品/保健品-休闲零食-调味品"],

      ["食品饮料、保健品-酒饮冲调-洋酒","食品/保健品-酒水饮料-洋酒"],
      ["食品饮料、保健品-酒饮冲调-啤酒","食品/保健品-酒水饮料-啤酒"],
      ["食品饮料、保健品-酒饮冲调-咖啡/奶茶","食品/保健品-酒水饮料-咖啡"],
      ["食品饮料、保健品-酒饮冲调-白酒/黄酒","食品/保健品-酒水饮料-白酒"],
      ["食品饮料、保健品-酒饮冲调-咖啡/茗茶","食品/保健品-酒水饮料-茶叶"],
      ["食品饮料、保健品-酒饮冲调-白酒/饮料","食品/保健品-酒水饮料-饮料"],

      ["食品饮料、保健品-预防保健-高血脂保健","药品-心脑血管-高血脂"],
      ["食品饮料、保健品-预防保健-高血压保健","药品-心脑血管-高血压"],
      ["食品饮料、保健品-预防保健-糖尿病保健","药品-糖尿病-无糖食品"],
      ["食品饮料、保健品-预防保健-心脑血管病保健","药品-心脑血管-动脉硬化"],

      ["食品饮料、保健品-营养健康-基础营养","食品/保健品-保健品-品牌保健品"],
      ["食品饮料、保健品-营养健康-滋补调养","食品/保健品-保健品-传统滋补"],
      ["食品饮料、保健品-营养健康-美体养颜","食品/保健品-保健品-胶原蛋白"],
      ["食品饮料、保健品-营养健康-骨骼健康","食品/保健品-保健品-钙片"],

      ["食品饮料、保健品-健康礼品-参茸礼品","其他-礼品/礼物-其他礼品"],
      ["食品饮料、保健品-健康礼品-更多礼品","其他-礼品/礼物-其他礼品"]
    ]

    MOBILE_DIGITAL_LIST = ["手机","对讲机","手机电池","蓝牙耳机","手机充电器","手机耳机","手机贴膜",
      "手机存储卡","手机保护套","数码相机","单电/微单相机","单反相机","摄像机",
      "单反镜头","滤镜","单反配件","存储卡","电池/充电器","读卡器","移动电源",
      "数码包","数码贴膜","三脚架/云台","相机清洁","MP3/MP4","MID","耳机",
      "音箱","其它配件","高清播放器","电子书","电子词典","录音笔","麦克风",
      "数码相框","空调","冰箱","洗衣机","平板电视","热水器","烟机/灶具",
      "消毒柜/洗碗机","家庭影院","DVD播放机","电风扇","空调扇","净化器",
      "饮水机","加湿器","吸尘器","豆浆机","料理/榨汁机","微波炉","电压力锅","电饭煲","电水壶/热水瓶",
      "电磁炉","笔记本","上网本","平板电脑","台式机","服务器","笔记本配件","移动硬盘","路由器",
      "交换机","网络存储","打印机","传真机","扫描仪","墨盒","硒鼓","墨粉","色带","投影机",
      "网卡","CPU","主板","显卡","硬盘","内存","机箱","显示器","散热器","刻录机/光驱","电源",
      "瑞士品牌","日本品牌","国产品牌","时尚品牌","儿童手表","闹钟挂钟","眼镜"
      #  "衬衫","T恤","针织","外套","裤子","裙子","孕妇装","运动装","运动鞋","运动配件",
      #  "文胸","内裤","背心","塑身","睡衣","家居","袜子","情趣",
      #,"腰带","帽子","围巾","手套","领带","袖扣","女鞋","男鞋","童鞋","拖鞋",
      # "男童","女童","宝宝服饰","亲子装", "健身器械","运动器材","极限运动","自行车及配件","防护器具",
      #  "羽毛球用品","乒乓球用品","篮球用品","足球用品","网球用品","排球用品","高尔球用品","台球用品","棋牌"
      #"帐篷","睡袋","登山攀岩","户外背包","户外照明","户外垫子","户外仪表","户外工具","望远镜","垂钓用品",
      #"旅游用品","泳衣","泳镜/泳帽","泳圈玩具","便携桌椅床","烧烤用品","野餐炊具"
    ]

    BRAND_LIST = ["BOE/京东方","Pangoo/盘古","樱雪","金正","山水","拓步","迈科","美菱","奥得奥",
      "丰鸾","哥尔","小鸭","小狗","龙的","益节","赛康","客浦","爱德","韩派","雷纳",
      "北鼎","松雷","立客","明基","E能之芯","日本SANWA","梵睿","莱盛光标","马克华菲","旅之星","莱克斯",
      "猫人","OBM","佛伦斯","朗悦","大金","卡西欧CASIO","天王表","依时名表","爱华时Alfex",
      "丹麦Obaku","ARMANI","SEIDIO","德国01"
    ]

    def end_product
      #     name_str = product.page.category.name
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")

      origin_base_map(CATEGORY_MAP,route_str)
      #     puts route_str
      #     (EndProduct.where(:name => /^(.*?)(#{name_str})/i).first)
    end

    def merchant
      get_merchant("京东商城")

    end

    def brand

      if MOBILE_DIGITAL_LIST.include?(product.page.category.name)

        name_str = doc.css(".crumb > a")[4].content
        BRAND_LIST.map do |brand|
          if name_str.index(brand)==0  
            name_str = brand
            break
          end
        end

        name_str = name_str.gsub(/\//,"\\/").gsub("）"," ").gsub("（"," ").gsub("("," ").gsub(")"," ")

        if name_str.index("...")
          name_str = ""
        end

        if name_str != ""
          brandobj = Brand.where(:name => /^(.*?)(#{name_str})/i).first
          if brandobj.nil?
            brand = Brand.create(:name =>name_str,:datatype=>"B2C",:order_num=>100000)
          else
            brand = brandobj
          end
        end
      end
      brand
    end

    def brand_type
      if MOBILE_DIGITAL_LIST.include?(product.page.category.name)
        if doc.css(".crumb > a")[5].nil?
          name_str = ""
        else
          name_str = doc.css(".crumb > a")[5].content
        end

        name_str = name_str.gsub(/\//,"\\/").gsub("）"," ").gsub("（"," ").gsub("("," ").gsub(")"," ")
        if name_str.index("...")
          name_str = ""
        end

        if name_str != ""
          brandtypeobj = BrandType.where(:name => /^(.*?)(#{name_str})/i).first
          if brandtypeobj.nil?
            brand_type = BrandType.create(:name =>name_str,:brand=>brand)
          else
            brand_type = brandtypeobj
          end
        end
      end
      brand_type
    end

    def product_code
      doc.css("#summary li:first span").text.gsub(/(商品编号：)/,"")
    end
    
    def title
      doc.css("div#name h1/text()").text
    end

    def price
    end
    
    def price_url
      doc.css("strong.price img").first["src"]
    end

    def stock
      return 1 if doc.css("#stocktext").text =~ /发货/
      return 0 if doc.css("#stocktext").text =~ /售完/
      logger.info("stock issue!")
      0
    end

    def image_url
      doc.css("#preview img").first["src"]
    end

    def get_union_url
      "http://click.union.360buy.com/JdClick/?unionId=15225&t=4&to=" + product.url
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
    
    def score
      doc.css("div[id^=star] div:first").first["class"].gsub(/[\D]+/, "").to_i
    end
    
    def standard
      doc.css(".Ptable").to_html
    end

    def desc
      doc.css(".mc.fore.tabcon").to_html
    end
    
    def comments
      #http://club.360buy.com/clubservice/productcomment-495087-5-0.+html
      []
    end

    def belongs_to_categories
      doc.css(".crumb a").select{|elem| elem["href"] =~ /products|com\/\w+\.html$/}.map do |elem|
        {
          :name => elem.inner_text,
          :url  => elem["href"]
        }
      end
    end
  end
end
