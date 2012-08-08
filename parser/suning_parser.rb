# encoding: utf-8
require "nokogiri"
require 'open-uri'

module Spider
  class SuningParser < Parser

    CATEGORY_MAP = [
      ["充值、缴费-话费充值-移动", "其他-虚拟充值-移动"],
      ["充值、缴费-话费充值-电信", "其他-虚拟充值-电信"],
      ["充值、缴费-话费充值-联通", "其他-虚拟充值-联通"],
      ["充值、缴费-生活缴费-水费", "其他-虚拟充值-水费"],
      ["充值、缴费-生活缴费-电费", "其他-虚拟充值-电费"],
      ["充值、缴费-生活缴费-燃气费", "其他-虚拟充值-燃气费"],

      ["手机、配件-手机-GSM", "电脑手机数码-手机通讯-普通手机"],
      ["手机、配件-手机-联通3G", "电脑手机数码-手机通讯-智能手机"],
      ["手机、配件-手机-电信3G", "电脑手机数码-手机通讯-智能手机"],
      ["手机、配件-手机-移动3G", "电脑手机数码-手机通讯-智能手机"],
      ["手机、配件-手机-CDMA", "电脑手机数码-手机通讯-普通手机"],
      ["手机、配件-充电配件-手机电池", "电脑手机数码-手机配件-手机电池"],
      ["手机、配件-充电配件-充电器", "电脑手机数码-手机配件-手机充电器"],
      ["手机、配件-充电配件-备用电源", "电脑手机数码-手机配件-其它配件"],
      ["手机、配件-音频配件-蓝牙耳机", "电脑手机数码-手机配件-蓝牙耳机"],
      ["手机、配件-音频配件-有线耳机", "电脑手机数码-手机配件-手机耳机"],
      ["手机、配件-音频配件-手机音箱", "电脑手机数码-手机配件-其它配件"],
      ["手机、配件-手机饰品-手机套", "电脑手机数码-手机配件-手机保护套"],
      ["手机、配件-手机饰品-保护膜", "电脑手机数码-手机配件-手机贴膜"],
      ["手机、配件-手机饰品-手机后壳", "电脑手机数码-手机配件-其它配件"],
      ["手机、配件-手机饰品-挂件", "电脑手机数码-手机配件-手机挂件"],
      ["手机、配件-手机饰品-手写笔", "电脑手机数码-手机配件-其它配件"],
      ["手机、配件-数据配件-存储卡", "电脑手机数码-手机配件-手机存储卡"],
      ["手机、配件-数据配件-读卡器", "电脑手机数码-手机配件-其它配件"],
      ["手机、配件-数据配件-数据线", "电脑手机数码-手机配件-手机数据线"],
      ["手机、配件-数据配件-3G上网卡", "电脑手机数码-手机配件-其它配件"],
      ["手机、配件-车载配件-车载支架", "电脑手机数码-手机配件-车载手机配件"],
      ["手机、配件-车载配件-车载充电器", "电脑手机数码-手机配件-车载手机配件"],
      ["手机、配件-苹果专区-苹果系列保护膜", "电脑手机数码-手机配件-苹果专用配件"],
      ["手机、配件-苹果专区-苹果系列保护套", "电脑手机数码-手机配件-苹果专用配件"],
      ["手机、配件-苹果专区-苹果系列移动电源", "电脑手机数码-手机配件-苹果专用配件"],
      ["手机、配件-苹果专区-苹果系列配件", "电脑手机数码-手机配件-苹果专用配件"],

      ["数码、电子-摄影摄像-数码相机", "电脑手机数码-数码摄像-数码相机"],
      ["数码、电子-摄影摄像-数码摄像机", "电脑手机数码-数码摄像-数码摄像机"],
      ["数码、电子-摄影摄像-单反相机", "电脑手机数码-数码摄像-单反相机"],
      ["数码、电子-时尚影音-MP3/MP4", "电脑手机数码-时尚影音-MP3/MP4"],
      ["数码、电子-时尚影音-数码相框", "电脑手机数码-时尚影音-数码相框"],
      ["数码、电子-时尚影音-录音笔", "电脑手机数码-时尚影音-录音笔"],
      ["数码、电子-时尚影音-移动电视", "电脑手机数码-时尚影音-其他"],
      ["数码、电子-时尚影音-收录机", "家电/办公-小家电-收录音机"],
      ["数码、电子-时尚影音-播放器配件", "电脑手机数码-时尚影音-其他"],
      ["数码、电子-照摄配件-摄影包", "电脑手机数码-数码配件-数码包"],
      ["数码、电子-照摄配件-电池/充电器", "电脑手机数码-数码配件-电池/充电器"],
      ["数码、电子-照摄配件-存储卡", "电脑手机数码-数码配件-存储卡"],
      ["数码、电子-照摄配件-读卡器", "电脑手机数码-数码配件-读卡器"],
      ["数码、电子-照摄配件-液晶膜", "电脑手机数码-数码摄像-其它"],
      ["数码、电子-照摄配件-配件套装", "电脑手机数码-数码摄像-其它"],
      ["数码、电子-照摄配件-清洁工具", "电脑手机数码-数码配件-相机清洁"],
      ["数码、电子-单反配件-单反镜头", "电脑手机数码-数码摄像-单反镜头"],
      ["数码、电子-单反配件-三脚架/云台", "电脑手机数码-数码配件-三角架/云台"],
      ["数码、电子-单反配件-滤镜", "电脑手机数码-数码摄像-滤镜"],
      ["数码、电子-单反配件-闪光灯", "电脑手机数码-数码摄像-闪光灯"],
      ["数码、电子-单反配件-镜头附件", "电脑手机数码-数码摄像-单反配件"],
      ["数码、电子-单反配件-手柄", "电脑手机数码-数码摄像-手柄"],
      ["数码、电子-单反配件-单反其他配件", "电脑手机数码-数码配件-其他"],
      ["数码、电子-耳机/耳麦-耳机", "电脑手机数码-时尚影音-耳机"],
      ["数码、电子-耳机/耳麦-耳麦", "电脑手机数码-时尚影音-耳机"],
      ["数码、电子-电子教育-电纸书", "电脑手机数码-时尚影音-电子书"],
      ["数码、电子-电子教育-电子辞典", "电脑手机数码-时尚影音-电子词典"],
      ["数码、电子-电子教育-点读机", "电脑手机数码-时尚影音-点读笔/点读机"],
      ["数码、电子-电子教育-学习机", "电脑手机数码-时尚影音-学习机/学生电脑"],
      ["数码、电子-电子教育-复读机", "电脑手机数码-时尚影音-复读机"],
      ["数码、电子-电子教育-手写板", "电脑手机数码-时尚影音-其他"],
      ["数码、电子-电玩游戏-跳舞毯", "电脑手机数码-时尚影音-其他"],
      ["数码、电子-电玩游戏-望远镜", "电脑手机数码-时尚影音-其他"],
      ["数码、电子-电玩游戏-游戏机", "电脑手机数码-时尚影音-其他"],
      ["电脑、配件、办公-笔记本电脑-笔记本", "电脑手机数码-电脑整机-笔记本"],
      ["电脑、配件、办公-笔记本电脑-上网本", "电脑手机数码-电脑整机-上网本"],
      ["电脑、配件、办公-笔记本电脑-平板电脑", "电脑手机数码-电脑整机-平板电脑"],
      ["电脑、配件、办公-笔记本电脑-MID平板", "电脑手机数码-电脑整机-笔记本配件"],
      ["电脑、配件、办公-办公设备-多功能一体机", "家电/办公-办公设备-一体机"],
      ["电脑、配件、办公-办公设备-打印机", "家电/办公-办公设备-打印机"],
      ["电脑、配件、办公-办公设备-电话机", "家电/办公-小家电-电话"],
      ["电脑、配件、办公-办公设备-扫描仪", "家电/办公-办公设备-扫描仪"],
      ["电脑、配件、办公-办公设备-投影仪", "家电/办公-办公设备-投影仪"],
      ["电脑、配件、办公-办公设备-传真机", "家电/办公-办公设备-传真机"],
      ["电脑、配件、办公-办公设备-复印机", "家电/办公-办公设备-复印机"],
      ["电脑、配件、办公-办公设备-考勤机", "家电/办公-办公设备-考勤机"],
      ["电脑、配件、办公-办公设备-点钞机", "家电/办公-办公设备-点钞机"],
      ["电脑、配件、办公-办公设备-碎纸机", "家电/办公-办公设备-碎纸机"],
      ["电脑、配件、办公-办公设备-验钞机", "家电/办公-办公设备-其他办公用品"],
      ["电脑、配件、办公-办公设备-计算器", "家电/办公-办公设备-办公文具"],
      ["电脑、配件、办公-办公设备-收款机", "家电/办公-办公设备-其他办公用品"],
      ["电脑、配件、办公-办公设备-装订机", "家电/办公-办公设备-装订机"],
      ["电脑、配件、办公-办公设备-对讲机", "电脑手机数码-手机通讯-对讲机"],
      ["电脑、配件、办公-电脑外设配件-移动硬盘", "电脑手机数码-电脑配件-硬盘"],
      ["电脑、配件、办公-电脑外设配件-键鼠套装", "电脑手机数码-电脑外设产品-鼠标垫"],
      ["电脑、配件、办公-电脑外设配件-电脑音箱", "电脑手机数码-电脑外设产品-音箱"],
      ["电脑、配件、办公-电脑外设配件-鼠标", "电脑手机数码-电脑外设产品-鼠标"],
      ["电脑、配件、办公-电脑外设配件-键盘", "电脑手机数码-电脑外设产品-键盘"],
      ["电脑、配件、办公-电脑外设配件-游戏设备", "电脑手机数码-电脑外设产品-游戏设备"],
      ["电脑、配件、办公-电脑外设配件-电脑包", "电脑手机数码-数码配件-数码包"],
      ["电脑、配件、办公-电脑外设配件-U盘", "电脑手机数码-电脑外设产品-U盘"],
      ["电脑、配件、办公-电脑外设配件-摄像头", "电脑手机数码-电脑外设产品-摄像头"],
      ["电脑、配件、办公-电脑外设配件-散热垫", "电脑手机数码-电脑配件-散热器"],
      ["电脑、配件、办公-电脑外设配件-USB外设", "电脑手机数码-电脑外设产品-UPS电源"],
      ["电脑、配件、办公-电脑外设配件-保护膜", "电脑手机数码-电脑外设产品-其它电脑附件"],
      ["电脑、配件、办公-电脑外设配件-鼠标垫", "电脑手机数码-电脑外设产品-鼠标垫"],
      ["电脑、配件、办公-电脑外设配件-电脑清洁工具", "电脑手机数码-电脑外设产品-电脑清洁"],
      ["电脑、配件、办公-台式电脑-显示器", "电脑手机数码-电脑外设产品-显示器"],
      ["电脑、配件、办公-台式电脑-台式主机", "电脑手机数码-电脑整机-台式机"],
      ["电脑、配件、办公-台式电脑-台式电脑", "电脑手机数码-电脑整机-台式机"],
      ["电脑、配件、办公-台式电脑-电脑一体机", "电脑手机数码-电脑整机-台式机"],
      ["电脑、配件、办公-办公耗材-硒鼓", "家电/办公-办公设备-硒鼓"],
      ["电脑、配件、办公-办公耗材-墨盒", "家电/办公-办公设备-墨盒"],
      ["电脑、配件、办公-办公耗材-墨粉", "家电/办公-办公设备-墨粉"],
      ["电脑、配件、办公-办公耗材-粉仓", "家电/办公-办公设备-办公用品配件"],
      ["电脑、配件、办公-办公耗材-色带", "家电/办公-办公设备-色带"],
      ["电脑、配件、办公-办公耗材-纸类", "家电/办公-办公设备-纸品"],
      ["电脑、配件、办公-办公耗材-其它", "家电/办公-办公设备-办公用品配件"],
      ["电脑、配件、办公-DIY硬件-笔记本随机配件", "电脑手机数码-电脑整机-笔记本配件"],
      ["电脑、配件、办公-DIY硬件-机箱", "电脑手机数码-电脑配件-机箱"],
      ["电脑、配件、办公-DIY硬件-散热器", "电脑手机数码-电脑配件-散热器"],
      ["电脑、配件、办公-DIY硬件-电池/适配器", "电脑手机数码-电脑配件-电源"],
      ["电脑、配件、办公-DIY硬件-电源", "电脑手机数码-电脑配件-电源"],
      ["电脑、配件、办公-DIY硬件-硬盘", "电脑手机数码-电脑配件-硬盘"],
      ["电脑、配件、办公-DIY硬件-光驱/刻录机", "电脑手机数码-电脑配件-刻录机"],
      ["电脑、配件、办公-网络设备-路由器", "电脑手机数码-电脑网络产品-有线路由器 "],
      ["电脑、配件、办公-网络设备-3G上网", "电脑手机数码-电脑网络产品-3G网络设备"],
      ["电脑、配件、办公-网络设备-交换机", "电脑手机数码-电脑网络产品-交换机"],
      ["电脑、配件、办公-网络设备-网卡", "电脑手机数码-电脑网络产品-无线网卡"],
      ["电脑、配件、办公-网络设备-网络存储", "电脑手机数码-电脑网络产品-网络存储"],
      ["电脑、配件、办公-电脑软件-操作系统", "电脑手机数码-电脑软件-系统软件"],
      ["电脑、配件、办公-电脑软件-财务软件", "电脑手机数码-电脑软件-办公软件"],
      ["电脑、配件、办公-电脑软件-工具软件", "电脑手机数码-电脑软件-办公软件"],
      ["电脑、配件、办公-电脑软件-杀毒软件", "电脑手机数码-电脑软件-杀毒软件"],
      ["电脑、配件、办公-办公家具-保险柜", "家电/办公-办公设备-保险箱/柜"],
      ["电脑、配件、办公-办公家具-电脑桌", "家电/办公-办公设备-办公文具"],
      ["电脑、配件、办公-办公文具-文具", "家电/办公-办公设备-办公文具"],
      ["电脑、配件、办公-办公文具-图书", "家电/办公-办公设备-办公文具"],
      ["电脑、配件、办公-办公文具-光盘包", "家电/办公-办公设备-办公用品配件"],

      ["生活电器、个人护理-季节性电器-取暖器", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-油汀", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-暖风机", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-电热毯", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-暖脚炉", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-暖手炉", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-电风扇", "家电/办公-生活家电-电风扇"],
      ["生活电器、个人护理-季节性电器-电热袋", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-空调扇", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-季节性电器-冰垫", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-个人护理电器-剃须刀", "家电/办公-小家电-剃须刀"],
      ["生活电器、个人护理-个人护理电器-电吹风", "家电/办公-小家电-电吹风"],
      ["生活电器、个人护理-个人护理电器-美容美发器", "家电/办公-小家电-电吹风"],
      ["生活电器、个人护理-个人护理电器-剃毛器", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-个人护理电器-电动牙刷", "家电/办公-小家电-电动牙刷"],
      ["生活电器、个人护理-加湿/净化器-除湿机", "家电/办公-生活家电-加湿器"],
      ["生活电器、个人护理-加湿/净化器-加湿器", "家电/办公-生活家电-加湿器"],
      ["生活电器、个人护理-加湿/净化器-空气净化器", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-运动保健-足浴盆", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-运动保健-跑步机/踏步机/健身车", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-运动保健-健康秤", "家居家纺-生活日用-健康秤"],
      ["生活电器、个人护理-运动保健-其他按摩保健器械", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-运动保健-按摩器/按摩垫", "家电/办公-生活家电-按摩器"],
      ["生活电器、个人护理-运动保健-按摩椅", "家电/办公-生活家电-按摩器"],
      ["生活电器、个人护理-清洁电器-吸尘器", "家电/办公-生活家电-吸尘器"],
      ["生活电器、个人护理-清洁电器-清洁机", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-测疗电子-电子血压计", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-测疗电子-体温计", "家电/办公-小家电-电子体温计"],
      ["生活电器、个人护理-测疗电子-测疗仪", "家电/办公-生活家电-家电配件"],
      ["生活电器、个人护理-衣物护理电器-挂烫机", "家居家纺-清洁用品-衣物清洁"],
      ["生活电器、个人护理-衣物护理电器-电熨斗", "家居家纺-清洁用品-衣物清洁"],
      ["生活电器、个人护理-衣物护理电器-毛球修剪器", "家居家纺-清洁用品-衣物清洁"],
      ["生活电器、个人护理-衣物护理电器-干衣架", "家居家纺-清洁用品-衣物清洁"],
      ["生活电器、个人护理-衣物护理电器-缝纫机", "家居家纺-生活日用-缝纫用品"],
      ["生活电器、个人护理-照明器材-台灯", "家居家纺-灯具-台灯"],
      ["生活电器、个人护理-照明器材-移动照明", "家居家纺-灯具-手电"],
      ["生活电器、个人护理-照明器材-节能灯", "家居家纺-灯具-节能灯"],
      ["生活电器、个人护理-照明器材-吸顶灯", "家居家纺-灯具-吸项灯"],
      ["生活电器、个人护理-照明器材-餐吊灯", "家居家纺-灯具-花灯吊灯"],
      ["生活电器、个人护理-照明器材-镜前灯", "家居家纺-灯具-护眼灯"],
      ["生活电器、个人护理-照明器材-灭蚊灯", "家居家纺-灯具-多用灯"],
      ["生活电器、个人护理-照明器材-小夜灯", "家居家纺-灯具-装饰灯"],
      ["生活电器、个人护理-照明器材-盐灯", "家居家纺-灯具-多用灯"],
      ["生活电器、个人护理-照明器材-落地灯", "家居家纺-灯具-多用灯"],
      ["生活电器、个人护理-五金工具-插线板/转换器", "家居家纺-家装建材-插座"],
      ["生活电器、个人护理-五金工具-线材/配件", "家居家纺-家装建材-五金工具"],
      ["生活电器、个人护理-五金工具-门铃", "家居家纺-家装建材-门窗"],
      ["生活电器、个人护理-五金工具-手动工具", "家居家纺-家装建材-五金工具"],
      ["生活电器、个人护理-五金工具-定时器", "家居家纺-家装建材-五金工具"],
      ["生活电器、个人护理-五金工具-开关/插座", "家居家纺-家装建材-插座"],
      ["生活电器、个人护理-五金工具-电池/充电器", "家居家纺-家装建材-五金工具"],
      ["生活电器、个人护理-五金工具-家具五金", "家居家纺-家装建材-五金工具"],

      ["厨房电器、卫浴-厨房电器-油烟机", "家电/办公-厨房家电-油烟机"],
      ["厨房电器、卫浴-厨房电器-燃气灶", "家电/办公-厨房家电-燃气灶"],
      ["厨房电器、卫浴-厨房电器-消毒柜", "家电/办公-厨房家电-消毒柜/洗碗机"],
      ["厨房电器、卫浴-厨房电器-洗碗机", "家电/办公-厨房家电-消毒柜/洗碗机"],
      ["厨房电器、卫浴-厨房电器-洗菜机", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-厨房电器-嵌入式烤箱", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-厨房小电器-豆浆机", "家电/办公-厨房家电-豆浆机"],
      ["厨房电器、卫浴-厨房小电器-微波炉", "家电/办公-厨房家电-微波炉"],
      ["厨房电器、卫浴-厨房小电器-电饭煲", "家电/办公-厨房家电-电饭煲"],
      ["厨房电器、卫浴-厨房小电器-电水壶/热水瓶", "家电/办公-厨房家电-电水壶"],
      ["厨房电器、卫浴-厨房小电器-电磁炉", "家电/办公-厨房家电-电磁炉"],
      ["厨房电器、卫浴-厨房小电器-电压力锅", "家电/办公-厨房家电-电压力锅"],
      ["厨房电器、卫浴-厨房小电器-料理机/榨汁机", "家电/办公-厨房家电-榨汁机"],
      ["厨房电器、卫浴-厨房小电器-烤箱", "家电/办公-厨房家电-电烤箱"],
      ["厨房电器、卫浴-厨房小电器-面包机/多士炉", "家电/办公-厨房家电-面包机"],
      ["厨房电器、卫浴-厨房小电器-咖啡壶/咖啡机", "家电/办公-厨房家电-咖啡机"],
      ["厨房电器、卫浴-厨房小电器-煮蛋器", "家电/办公-厨房家电-煮蛋器"],
      ["厨房电器、卫浴-厨房小电器-电蒸锅", "家居家纺-厨房用具-蒸锅"],
      ["厨房电器、卫浴-厨房小电器-多用途锅", "家电/办公-厨房家电-锅"],
      ["厨房电器、卫浴-厨房小电器-电饼铛/煎烤机", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-厨房小电器-酸奶机", "家电/办公-厨房家电-酸奶机"],
      ["厨房电器、卫浴-厨房小电器-炊具", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-厨房小电器-打蛋器", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-厨房小电器-刀具", "家居家纺-厨房用具-刀具"],
      ["厨房电器、卫浴-厨房小电器-电火锅", "家电/办公-厨房家电-锅"],
      ["厨房电器、卫浴-厨房小电器-电炖锅", "家电/办公-厨房家电-锅"],
      ["厨房电器、卫浴-厨房小电器-豆料", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-厨房小电器-豆芽机", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-厨房小电器-餐具", "家居家纺-精美餐具-套装美食工具"],
      ["厨房电器、卫浴-厨房小电器-小工具", "家电/办公-厨房家电-其他"],
      ["厨房电器、卫浴-卫浴电器-电热水器", "家电/办公-生活家电-热水器"],
      ["厨房电器、卫浴-卫浴电器-燃气热水器", "家电/办公-生活家电-热水器"],
      ["厨房电器、卫浴-卫浴电器-洁身器", "家居家纺-清洁用品-卫浴清洁"],
      ["厨房电器、卫浴-卫浴电器-太阳能热水器", "家电/办公-生活家电-热水器"],
      ["厨房电器、卫浴-饮水设备-饮水机", "家电/办公-厨房家电-饮水机"],
      ["厨房电器、卫浴-饮水设备-净水桶", "家电/办公-厨房家电-净化器"],
      ["厨房电器、卫浴-饮水设备-净水设备", "家电/办公-厨房家电-净化器"],
      ["厨房电器、卫浴-卫浴配件-浴霸", "家电/办公-小家电-浴霸"],
      ["厨房电器、卫浴-卫浴配件-花洒", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-五金龙头", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-水槽", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-排水器", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-软管", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-角阀", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-水箱", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-垃圾桶", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-烟管", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-地垫", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-五金配件", "家居家纺-生活日用-浴室用品"],
      ["厨房电器、卫浴-卫浴配件-洗漱用品", "家居家纺-生活日用-浴室用品"],

      ["家用电器、汽车用品-冰箱-三门冰箱", "家电/办公-生活家电-冰箱"],
      ["家用电器、汽车用品-冰箱-双门冰箱", "家电/办公-生活家电-冰箱"],
      ["家用电器、汽车用品-冰箱-对开门冰箱", "家电/办公-生活家电-冰箱"],
      ["家用电器、汽车用品-冰箱-单门冰箱", "家电/办公-生活家电-冰箱"],
      ["家用电器、汽车用品-冰箱-多门冰箱", "家电/办公-生活家电-冰箱"],
      ["家用电器、汽车用品-冰箱-车载冰箱", "汽车用品-汽车电器-车载冰箱"],
      ["家用电器、汽车用品-家用空调-家用挂机", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-家用空调-家用柜机", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-汽车用品-车载GPS", "汽车用品-导航通讯-GPS导航"],
      ["家用电器、汽车用品-汽车用品-香水/净化", "汽车用品-车内用品-空气净化"],
      ["家用电器、汽车用品-汽车用品-座垫/内饰", "汽车用品-车内饰品-摆件/挂饰"],
      ["家用电器、汽车用品-汽车用品-车载冷暖箱", "汽车用品-汽车电器-其他"],
      ["家用电器、汽车用品-汽车用品-美容/养护", "汽车用品-养护用品-其他"],
      ["家用电器、汽车用品-汽车用品-充气/吸尘", "汽车用品-汽车电器-车用吸尘器"],
      ["家用电器、汽车用品-汽车用品-车载电器", "汽车用品-汽车电器-车载冰箱"],
      ["家用电器、汽车用品-汽车用品-电源/插座", "汽车用品-导航通讯-车载电源"],
      ["家用电器、汽车用品-汽车用品-儿童安全座椅", "汽车用品-安全防盗-儿童座椅"],
      ["家用电器、汽车用品-汽车用品-其他装饰用品", "汽车用品-车内饰品-其他"],
      ["家用电器、汽车用品-洗衣机-波轮", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机-滚筒", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机-双缸", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机-迷你洗衣机", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机-干衣机", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-商用空调-商用风管机", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-商用空调-商用柜机", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-商用空调-商用嵌入机", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-冷柜-展示柜", "家电/办公-厨房家电-酒柜/冷柜"],
      ["家用电器、汽车用品-冷柜-卧式冷柜", "家电/办公-厨房家电-酒柜/冷柜"],
      ["家用电器、汽车用品-冷柜-酒柜", "家电/办公-厨房家电-酒柜/冷柜"],
      ["家用电器、汽车用品-冷柜-立式冷柜", "家电/办公-厨房家电-酒柜/冷柜"],
      ["家用电器、汽车用品-空调配件-插座、插头", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-空调配件-空气净化用品", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-空调配件-空调罩", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-空调配件-空调支架", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-空调配件-空调遥控器", "家电/办公-生活家电-空调"],
      ["家用电器、汽车用品-洗衣机附件-洗衣袋", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机附件-冰箱洗衣机托架", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机附件-水管", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机附件-水龙头", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机附件-洗衣机罩", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机附件-洗衣球", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-洗衣机附件-真空袋", "家电/办公-生活家电-洗衣机"],
      ["家用电器、汽车用品-冰箱周边-冰格", "家电/办公-生活家电-冰箱"],
      ["家用电器、汽车用品-冰箱周边-竹炭系列", "家电/办公-生活家电-冰箱"],

      ["电视、音响、乐器-电视-LED电视", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-液晶电视", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-3D电视", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-等离子电视", "家电/办公-生活家电-等离子电视"],
      ["电视、音响、乐器-电视-电视套餐", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-家庭影院", "家电/办公-生活家电-家庭影院"],
      ["电视、音响、乐器-电视-迷你音响", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-苹果专用音响", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-音箱", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-功放", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-CD/SACD播放器", "家电/办公-生活家电-播放器"],
      ["电视、音响、乐器-电视-混响器", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-电视-高保真耳机", "家电/办公-生活家电-液晶电视"],
      ["电视、音响、乐器-影音播放器-DVD", "家电/办公-生活家电-音响 DVD"],
      ["电视、音响、乐器-影音播放器-蓝光DVD", "家电/办公-生活家电-音响 DVD"],
      ["电视、音响、乐器-影音播放器-便携式DVD", "家电/办公-生活家电-音响 DVD"],
      ["电视、音响、乐器-影音播放器-高清播放器", "家电/办公-生活家电-音响 DVD"],
      ["电视、音响、乐器-乐器-键盘乐器", "学习教育-音乐器材-其他"],
      ["电视、音响、乐器-乐器-打击乐器", "学习教育-音乐器材-其他"],
      ["电视、音响、乐器-乐器-原声吉他", "学习教育-音乐器材-吉他"],
      ["电视、音响、乐器-乐器-古筝", "学习教育-音乐器材-古筝"],
      ["电视、音响、乐器-乐器-合成器", "学习教育-音乐器材-其他"],
      ["电视、音响、乐器-乐器-效果器", "学习教育-音乐器材-其他"],
      ["电视、音响、乐器-乐器-电吉他", "学习教育-音乐器材-吉他"],
      ["电视、音响、乐器-乐器-电贝司", "其他-文化娱乐-乐器"],
      ["电视、音响、乐器-乐器-节拍器", "其他-文化娱乐-乐器"],
      ["电视、音响、乐器-乐器-调音器", "其他-文化娱乐-乐器"],
      ["电视、音响、乐器-乐器-采样器", "其他-文化娱乐-乐器"],
      ["电视、音响、乐器-乐器-音箱", "电脑手机数码-时尚影音-音箱"],
      ["电视、音响、乐器-乐器-附件", "其他-文化娱乐-乐器"],
      ["电视、音响、乐器-配件-挂架/支架", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-底座", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-线材", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-分配器/转换头", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-机顶盒", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-遥控器", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-电子附件", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-电视机罩", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-清洁用品", "电脑手机数码-时尚影音-其他"],
      ["电视、音响、乐器-配件-话筒/麦克风", "电脑手机数码-时尚影音-其他"],

      ["服装鞋帽、皮具箱包-男鞋-运动鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["服装鞋帽、皮具箱包-男鞋-皮鞋", "鞋帽服饰-男鞋-正装鞋"],
      ["服装鞋帽、皮具箱包-男鞋-休闲鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["服装鞋帽、皮具箱包-男鞋-帆布鞋", "鞋帽服饰-男鞋-帆布鞋"],
      ["服装鞋帽、皮具箱包-男鞋-凉鞋", "鞋帽服饰-男鞋-凉鞋"],
      ["服装鞋帽、皮具箱包-男装-运动装", "服装-男装-T恤"],
      ["服装鞋帽、皮具箱包-男装-牛仔裤", "服装-男装-裤子"],
      ["服装鞋帽、皮具箱包-男装-外套", "服装-男装-上衣外套"],
      ["服装鞋帽、皮具箱包-男装-针织", "服装-男装-针织"],
      ["服装鞋帽、皮具箱包-男装-衬衫", "服装-男装-衬衫"],
      ["服装鞋帽、皮具箱包-男装-西装", "服装-男装-西服"],
      ["服装鞋帽、皮具箱包-男装-西裤", "服装-男装-裤子"],
      ["服装鞋帽、皮具箱包-男装-休闲裤", "服装-男装-裤子"],
      ["服装鞋帽、皮具箱包-男装-户外服装", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["服装鞋帽、皮具箱包-男装-T恤", "服装-男装-T恤"],
      ["服装鞋帽、皮具箱包-男装-马甲", "服装-男装-上衣外套"],
      ["服装鞋帽、皮具箱包-男装-内衣/内裤", "服装-内衣袜品-内裤"],
      ["服装鞋帽、皮具箱包-男装-家居服", "服装-内衣袜品-家居服"],
      ["服装鞋帽、皮具箱包-时尚箱包-时尚女包", "箱包皮具-潮流女包-多用包"],
      ["服装鞋帽、皮具箱包-时尚箱包-精品男包", "箱包皮具-时尚男包-经典商务包"],
      ["服装鞋帽、皮具箱包-时尚箱包-运动休闲包", "箱包皮具-旅行箱包-休闲包"],
      ["服装鞋帽、皮具箱包-时尚箱包-旅行箱包", "箱包皮具-旅行箱包-旅行包"],
      ["服装鞋帽、皮具箱包-时尚箱包-钱包", "箱包皮具-时尚男包-钱包"],
      ["服装鞋帽、皮具箱包-时尚箱包-其他功能包", "箱包皮具-旅行箱包-多功能背包"],
      ["服装鞋帽、皮具箱包-女鞋-运动鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["服装鞋帽、皮具箱包-女鞋-皮鞋", "鞋帽服饰-女鞋-正装鞋"],
      ["服装鞋帽、皮具箱包-女鞋-休闲鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["服装鞋帽、皮具箱包-女鞋-帆布鞋", "鞋帽服饰-女鞋-帆布鞋"],
      ["服装鞋帽、皮具箱包-女鞋-凉鞋", "鞋帽服饰-女鞋-凉鞋"],
      ["服装鞋帽、皮具箱包-女鞋-靴子", "鞋帽服饰-女鞋-靴子"],
      ["服装鞋帽、皮具箱包-女鞋-家居鞋", "鞋帽服饰-女鞋-其他款"],
      ["服装鞋帽、皮具箱包-女鞋-拖鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
      ["服装鞋帽、皮具箱包-女装-T恤", "服装-女装-T恤"],
      ["服装鞋帽、皮具箱包-女装-外套", "服装-女装-外套"],
      ["服装鞋帽、皮具箱包-女装-牛仔裤", "服装-女装-裤子"],
      ["服装鞋帽、皮具箱包-女装-针织", "服装-女装-针织衫"],
      ["服装鞋帽、皮具箱包-女装-衬衫", "服装-女装-衬衫"],
      ["服装鞋帽、皮具箱包-女装-运动装", "服装-女装-裤子"],
      ["服装鞋帽、皮具箱包-女装-休闲裤", "服装-女装-裤子"],
      ["服装鞋帽、皮具箱包-女装-裙装", "服装-女装-裙子"],
      ["服装鞋帽、皮具箱包-女装-户外服装", "服装-女装-西服/套装"],
      ["服装鞋帽、皮具箱包-女装-孕妇装", "服装-女装-外套"],
      ["服装鞋帽、皮具箱包-女装-马甲", "服装-女装-外套"],
      ["服装鞋帽、皮具箱包-女装-内衣/内裤", "服装-内衣袜品-内裤"],
      ["服装鞋帽、皮具箱包-女装-家居服", "服装-内衣袜品-家居服"],
      ["服装鞋帽、皮具箱包-服装配饰-围巾/丝巾", "鞋帽服饰-服饰配饰-围巾"],
      ["服装鞋帽、皮具箱包-服装配饰-腰带", "鞋帽服饰-服饰配饰-腰带"],
      ["服装鞋帽、皮具箱包-服装配饰-眼镜", "鞋帽服饰-服饰配饰-眼镜"],
      ["服装鞋帽、皮具箱包-服装配饰-发饰", "鞋帽服饰-服饰配饰-其他配饰"],
      ["服装鞋帽、皮具箱包-服装配饰-丝袜/裤袜", "鞋帽服饰-服饰配饰-袜子"],
      ["服装鞋帽、皮具箱包-服装配饰-袜子", "鞋帽服饰-服饰配饰-袜子"],
      ["服装鞋帽、皮具箱包-服装配饰-帽子", "鞋帽服饰-服饰配饰-帽子"],
      ["服装鞋帽、皮具箱包-服装配饰-胸针", "鞋帽服饰-服饰配饰-其他配饰"],
      ["服装鞋帽、皮具箱包-服装配饰-领带/领结", "鞋帽服饰-服饰配饰-领带"],
      ["服装鞋帽、皮具箱包-服装配饰-套装", "鞋帽服饰-服饰配饰-其他配饰"],
      ["服装鞋帽、皮具箱包-体育用品-足球用品", "运动户外-运动名品-足球用品"],
      ["服装鞋帽、皮具箱包-体育用品-篮球用品", "运动户外-运动名品-篮球用品"],
      ["服装鞋帽、皮具箱包-体育用品-羽毛球用品", "运动户外-运动名品-其他用品"],
      ["服装鞋帽、皮具箱包-体育用品-乒乓球用品", "运动户外-运动名品-其他用品"],
      ["服装鞋帽、皮具箱包-体育用品-网球用品", "运动户外-运动名品-网球用品"],
      ["服装鞋帽、皮具箱包-体育用品-排球用品", "运动户外-运动名品-其他用品"],
      ["服装鞋帽、皮具箱包-体育用品-游泳装备", "运动户外-运动名品-游泳用品"],
      ["服装鞋帽、皮具箱包-体育用品-护具", "运动户外-运动名品-康体保健"],
      ["服装鞋帽、皮具箱包-休闲健身-瑜伽用品", "运动户外-运动名品-瑜珈用品"],
      ["服装鞋帽、皮具箱包-休闲健身-运动器材", "运动户外-运动器械-骑行运动"],
      ["服装鞋帽、皮具箱包-户外用品-野餐烧烤", "运动户外-户外装备-野餐炊具"],
      ["服装鞋帽、皮具箱包-户外用品-运动水壶", "运动户外-户外装备-野餐炊具"],
      ["服装鞋帽、皮具箱包-户外用品-帐篷", "运动户外-户外装备-帐篷"],
      ["服装鞋帽、皮具箱包-户外用品-便携桌椅床", "运动户外-户外装备-便携桌椅床"],
      ["服装鞋帽、皮具箱包-户外用品-睡袋", "运动户外-户外装备-睡袋"],

      ["家居家纺、钟表首饰-床上用品-床品套件", "家居家纺-家纺-床品件套"],
      ["家居家纺、钟表首饰-床上用品-被毯", "家居家纺-家纺-被子"],
      ["家居家纺、钟表首饰-床上用品-枕芯枕套", "家居家纺-家纺-枕芯枕套"],
      ["家居家纺、钟表首饰-床上用品-坐垫/抱枕", "家居家纺-家纺-抱枕坐垫"],
      ["家居家纺、钟表首饰-床上用品-床品单件", "家居家纺-家纺-床单"],
      ["家居家纺、钟表首饰-床上用品-床垫", "家居家纺-家纺-毯子/床垫"],
      ["家居家纺、钟表首饰-床上用品-凉席", "家居家纺-家纺-蚊帐/凉席"],
      ["家居家纺、钟表首饰-床上用品-蚊帐", "家居家纺-家纺-蚊帐/凉席"],
      ["家居家纺、钟表首饰-清洁用品-日化清洁用品", "家居家纺-生活日用-清洁工具"],
      ["家居家纺、钟表首饰-清洁用品-衣物洗护", "家居家纺-清洁用品-衣物清洁"],
      ["家居家纺、钟表首饰-清洁用品-清洁工具", "家居家纺-生活日用-清洁工具"],
      ["家居家纺、钟表首饰-钟表首饰-手表", "珠宝配饰-手表钟表-时尚品牌"],
      ["家居家纺、钟表首饰-钟表首饰-戒指", "珠宝配饰-饰品配饰-戒指"],
      ["家居家纺、钟表首饰-钟表首饰-项链/吊坠", "珠宝配饰-饰品配饰-项链/项坠 "],
      ["家居家纺、钟表首饰-钟表首饰-耳环/耳钉/耳坠", "珠宝配饰-饰品配饰-耳环/耳饰"],
      ["家居家纺、钟表首饰-钟表首饰-手链/手镯", "珠宝配饰-饰品配饰-手链/脚链"],
      ["家居家纺、钟表首饰-钟表首饰-闹钟挂钟", "珠宝配饰-手表钟表-挂钟/闹钟"],
      ["家居家纺、钟表首饰-钟表首饰-情侣对饰", "珠宝配饰-手表钟表-其他表"],
      ["家居家纺、钟表首饰-钟表首饰-摆件/挂件", "珠宝配饰-饰品配饰-手机挂件"],
      ["家居家纺、钟表首饰-钟表首饰-套装", "珠宝配饰-饰品配饰-其他配饰"],
      ["家居家纺、钟表首饰-钟表首饰-金银藏品", "珠宝配饰-金银首饰-黄金铂金"],
      ["家居家纺、钟表首饰-钟表首饰-流行饰品", "珠宝配饰-其他配饰-其他"],
      ["家居家纺、钟表首饰-生活用品-保鲜盒/便当盒", "家居家纺-生活日用-收纳雨具"],
      ["家居家纺、钟表首饰-生活用品-毛巾浴巾", "家居家纺-家纺-毛巾浴巾"],
      ["家居家纺、钟表首饰-生活用品-收纳用具", "家居家纺-生活日用-收纳雨具"],
      #["家居家纺、钟表首饰-生活用品-安全用品", ""],
      ["家居家纺、钟表首饰-生活用品-卫浴用品", "家居家纺-生活日用-浴室用品"],
      ["家居家纺、钟表首饰-生活用品-厨房用品", "家居家纺-厨房用具-其它"],
      ["家居家纺、钟表首饰-生活用品-桌/椅", "家居家纺-家具-边桌/茶几"],
      ["家居家纺、钟表首饰-生活用品-水壶/水杯", "家居家纺-生活日用-收纳雨具"],
      ["家居家纺、钟表首饰-生活用品-炭净化", "家居家纺-生活日用-净化防潮"],
      ["家居家纺、钟表首饰-生活用品-装饰用品", "家居家纺-生活日用-家装软饰"],
      ["家居家纺、钟表首饰-生活用品-雨伞雨具", "家居家纺-生活日用-收纳雨具"],
      ["家居家纺、钟表首饰-生活用品-烫衣板", "家居家纺-生活日用-缝纫用品"],
      ["家居家纺、钟表首饰-生活用品-眼罩", "家居家纺-清洁用品-衣物清洁"],
      ["家居家纺、钟表首饰-生活用品-保健用品", "家居家纺-生活日用-健康秤"],
      ["家居家纺、钟表首饰-工艺礼品-瑞士军刀", "其他-礼品/礼物-瑞士军刀"],
      ["家居家纺、钟表首饰-工艺礼品-火机烟具", "其他-礼品/礼物-火机烟具"],
      ["家居家纺、钟表首饰-工艺礼品-酒壶", "其他-礼品/礼物-其他礼品"],
      ["家居家纺、钟表首饰-工艺礼品-工艺摆件", "其他-礼品/礼物-工艺摆件"],
      ["家居家纺、钟表首饰-工艺礼品-礼品礼券", "其他-礼品/礼物-礼品礼券"],
      ["家居家纺、钟表首饰-成人用品-安全避孕", "学习教育-成人艺体教育-其他"],
      ["家居家纺、钟表首饰-成人用品-情爱玩具", "学习教育-成人艺体教育-其他"],
      ["家居家纺、钟表首饰-成人用品-人体润滑", "学习教育-成人艺体教育-其他"],

      ["化妆洗护、母婴玩具-美容护肤-面部清洁", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-美容护肤-面霜乳液", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-美容护肤-眼部护理", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-美容护肤-护肤水", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-美容护肤-面膜面贴", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-美容护肤-精华", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-美容护肤-美容工具", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-美容护肤-护肤套装", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-母婴专区-喂养用品", "母婴-妈妈专区-孕妇奶粉"],
      ["化妆洗护、母婴玩具-母婴专区-尿裤湿巾", "母婴-日用品-纸尿裤"],
      ["化妆洗护、母婴玩具-母婴专区-童车童床", "母婴-日用品-婴儿床"],
      ["化妆洗护、母婴玩具-母婴专区-洗护用品", "母婴-日用品-孕婴清洁护肤"],
      ["化妆洗护、母婴玩具-母婴专区-寝具用品", "母婴-日用品-餐具"],
      ["化妆洗护、母婴玩具-母婴专区-婴童服饰", "母婴-童装-童鞋"],
      ["化妆洗护、母婴玩具-母婴专区-妈妈护理", "母婴-妈妈专区-个人护理"],
      ["化妆洗护、母婴玩具-母婴专区-童鞋", "母婴-童装-童鞋"],
      ["化妆洗护、母婴玩具-母婴专区-女童装", "母婴-童装-童鞋"],
      ["化妆洗护、母婴玩具-母婴专区-男童装", "母婴-童装-童鞋"],
      ["化妆洗护、母婴玩具-美发护发-洗发", "美容护肤-身体护理-洗发护发"],
      ["化妆洗护、母婴玩具-美发护发-护发", "美容护肤-身体护理-洗发护发"],
      ["化妆洗护、母婴玩具-美发护发-美发套装", "美容护肤-身体护理-洗发护发"],
      ["化妆洗护、母婴玩具-美发护发-发膜", "美容护肤-身体护理-洗发护发"],
      ["化妆洗护、母婴玩具-美发护发-造型", "美容护肤-身体护理-洗发护发"],
      ["化妆洗护、母婴玩具-美发护发-染发", "美容护肤-身体护理-洗发护发"],
      ["化妆洗护、母婴玩具-男士专区-面部清洁", "美容护肤-日常护肤-洁面"],
      ["化妆洗护、母婴玩具-男士专区-男士套装", "美容护肤-日常护肤-套装"],
      ["化妆洗护、母婴玩具-男士专区-护肤水", "美容护肤-日常护肤-护肤水"],
      ["化妆洗护、母婴玩具-男士专区-剃须", "美容护肤-身体护理-口腔手足"],
      ["化妆洗护、母婴玩具-男士专区-面部护理", "美容护肤-身体护理-其他"],
      ["化妆洗护、母婴玩具-男士专区-面膜面贴", "美容护肤-身体护理-其他"],
      ["化妆洗护、母婴玩具-男士专区-眼部护理", "美容护肤-身体护理-其他"],
      ["化妆洗护、母婴玩具-男士专区-手唇护理", "美容护肤-身体护理-口腔手足"],
      ["化妆洗护、母婴玩具-身体护理-清爽沐浴", "美容护肤-身体护理-沐浴"],
      ["化妆洗护、母婴玩具-身体护理-手足护理", "美容护肤-身体护理-口腔手足"],
      ["化妆洗护、母婴玩具-身体护理-身体乳霜", "美容护肤-日常护肤-乳液"],
      ["化妆洗护、母婴玩具-身体护理-口腔护理", "美容护肤-身体护理-口腔手足"],
      ["化妆洗护、母婴玩具-身体护理-卫生护理", "美容护肤-身体护理-生理护理"],
      ["化妆洗护、母婴玩具-身体护理-纤体瘦身", "美容护肤-身体护理-美体瘦身"],
      ["化妆洗护、母婴玩具-身体护理-香熏精油", "美容护肤-身体护理-香体止汗"],
      ["化妆洗护、母婴玩具-身体护理-护理套装", "美容护肤-身体护理-日用清洁"],
      ["化妆洗护、母婴玩具-彩妆/香水-唇膏/唇彩", "美容护肤-魅力彩妆-眼唇妆"],
      ["化妆洗护、母婴玩具-彩妆/香水-粉底/遮瑕", "美容护肤-魅力彩妆-粉底液"],
      ["化妆洗护、母婴玩具-彩妆/香水-粉饼", "美容护肤-魅力彩妆-粉底液"],
      ["化妆洗护、母婴玩具-彩妆/香水-BB霜", "美容护肤-魅力彩妆-BB 霜"],
      ["化妆洗护、母婴玩具-彩妆/香水-眼影", "美容护肤-魅力彩妆-眼影"],
      ["化妆洗护、母婴玩具-彩妆/香水-眉笔/眉粉", "美容护肤-魅力彩妆-眼唇妆"],
      ["化妆洗护、母婴玩具-彩妆/香水-睫毛膏", "美容护肤-魅力彩妆-睫毛膏"],
      ["化妆洗护、母婴玩具-彩妆/香水-隔离防晒", "美容护肤-魅力彩妆-隔离霜"],
      ["化妆洗护、母婴玩具-彩妆/香水-眼线", "美容护肤-魅力彩妆-眼唇妆"],
      ["化妆洗护、母婴玩具-彩妆/香水-唇线笔", "美容护肤-魅力彩妆-眼唇妆"],
      ["化妆洗护、母婴玩具-彩妆/香水-腮红/胭脂", "美容护肤-魅力彩妆-腮红胭脂"],
      ["化妆洗护、母婴玩具-彩妆/香水-美甲", "美容护肤-魅力彩妆-美容工具"],
      ["化妆洗护、母婴玩具-彩妆/香水-卸妆", "美容护肤-魅力彩妆-卸妆乳"],
      ["化妆洗护、母婴玩具-彩妆/香水-礼盒套装", "美容护肤-身体护理-香体止汗"],
      ["化妆洗护、母婴玩具-彩妆/香水-女士香水", "美容护肤-身体护理-香体止汗"],
      ["化妆洗护、母婴玩具-彩妆/香水-男士香水", "美容护肤-身体护理-香体止汗"],
      ["化妆洗护、母婴玩具-玩具-遥控玩具", "母婴-玩具-遥控玩具"],
      ["化妆洗护、母婴玩具-玩具-毛绒布艺", "母婴-玩具-毛绒玩具"],
      ["化妆洗护、母婴玩具-玩具-益智玩具", "母婴-玩具-益智类"],
      ["化妆洗护、母婴玩具-玩具-音乐玩具", "母婴-玩具-音乐玩具"],
      ["化妆洗护、母婴玩具-玩具-动漫人物", "母婴-玩具-动漫玩具"],
      ["化妆洗护、母婴玩具-玩具-模型", "母婴-玩具-模型玩具"],
      ["化妆洗护、母婴玩具-玩具-电子玩具", "母婴-玩具-电动玩具"],
      ["化妆洗护、母婴玩具-玩具-运动健身玩具", "母婴-玩具-户外玩具"],

    ]


    def title
      doc.css(".promsg_hd h2").inner_text
      #doc.css(".product_title_name").inner_text
    end

    def price
      begin
        p_arr = product.url.split("_")
        url = "http://www.suning.com/webapp/wcs/stores/servlet/snfdv_"+ p_arr[2] + "_" + p_arr[1] + "_" + p_arr[4] + "_" + p_arr[3] + "_9017_.html"
        p_doc = Nokogiri::HTML(open(url).read)
        p_doc.css("#yigou_money").text.gsub(/(￥)/, "")
      rescue Exception=>e
        puts "price url error"
        puts e.message
        puts e.backtrace.inspect
      else
      end
    end

    def stock
      doc.css("#deleverStatus").inner_text =~ /现货/ ? 1 : 0
    end

    def image_url
      doc.css(".product_b_image img").first["src"]
    end

    def desc
    end

    def price_url
    end

    def score
      5 - doc.css(".sn_stars em.noscore").count
    end

    def product_code
      doc.css(".product_title_cout").inner_text[/\d+/, 0].to_i
    end

    def standard
      ""
    end

    def comments
      []
    end

    def end_product
      route_str = product.page.category.ancestors_and_self.map do |cate|
        cate.name
      end.join("-")
      origin_base_map(CATEGORY_MAP,route_str)
    end

    def merchant
      get_merchant("苏宁易购")
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

    def belongs_to_categories
      doc.css(".path a").select{|elem| elem["href"] =~ /html/}.map do |elem|
        if elem["href"] =~ /webapp\/wcs\/stores\/servlet/
          fin_href = "http://www.suning.com"+elem["href"]
        else
          fin_href = "http://www.suning.com/webapp/wcs/stores/servlet/"+elem["href"]
        end
        {
          :name => elem.inner_text,
          :url  => fin_href#elem["href"]
        }
      end
    end
    
    def get_union_url
      product.url
    end
  end
end