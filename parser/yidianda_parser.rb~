# encoding: utf-8
require 'nokogiri'

module Spider
  class YidiandaParser < Parser
     CATEGORY_MAP = [
 ["手机通讯-手机-GSM手机", "电脑手机数码-手机通讯-智能手机"],
 ["手机通讯-手机-双模手机", "电脑手机数码-手机通讯-智能手机"],
 ["手机通讯-手机-3G手机", "电脑手机数码-手机通讯-智能手机"],
 ["手机通讯-手机-电信手机", "电脑手机数码-手机通讯-普通手机"],
 ["手机通讯-手机配件-手机电池", "电脑手机数码-手机配件-手机电池"],
 ["手机通讯-手机配件-手机充电器", "电脑手机数码-手机配件-手机充电器"],
 ["手机通讯-手机配件-蓝牙耳机", "电脑手机数码-手机配件-蓝牙耳机"],
 ["手机通讯-手机配件-数据配件", "电脑手机数码-手机配件-其它配件"],
 ["手机通讯-手机配件-手机保护套", "电脑手机数码-手机配件-手机保护套"],
 ["手机通讯-手机配件-手机耳机", "电脑手机数码-手机配件-手机耳机"],
 ["手机通讯-手机配件-手机车载配件", "电脑手机数码-手机配件-车载手机配件"],
 ["手机通讯-手机配件-手机贴膜", "电脑手机数码-手机配件-手机贴膜"],
 ["手机通讯-北京电信-0元购机", "电脑手机数码-手机通讯-选号入网"],
 ["手机通讯-北京电信-选号入网", "电脑手机数码-手机通讯-选号入网"],
 ["潮流数码-数码影像-便携相机", "电脑手机数码-数码摄像-便携相机"],
 ["潮流数码-数码影像-单反相机", "电脑手机数码-数码摄像-单反相机"],
 ["潮流数码-数码影像-数码摄像机", "电脑手机数码-数码摄像-数码摄像机"],
 ["潮流数码-数码影音-MP3/MP4", "电脑手机数码-时尚影音-MP3/MP4"],
 ["潮流数码-数码影音-GPS导航", "电脑手机数码-时尚影音-车载GPS"],
 ["潮流数码-数码影音-录音笔", "电脑手机数码-时尚影音-录音笔"],
 ["潮流数码-数码影音-数码相框", "电脑手机数码-时尚影音-数码相框"],
 ["潮流数码-数码影音-点读机", "电脑手机数码-时尚影音-点读笔/点读机"],
 ["潮流数码-数码影音-高清播放器", "电脑手机数码-时尚影音-高清播放器"],
 ["潮流数码-数码影音-电纸书", "电脑手机数码-时尚影音-电子书"],
 ["潮流数码-数码影音-多媒体机", "电脑手机数码-时尚影音-MID移动互联网终端"],
 ["潮流数码-数码配件-电池/充电器", "电脑手机数码-数码配件-电池/充电器"],
 ["潮流数码-数码配件-数码包", "电脑手机数码-数码配件-数码包"],
 ["潮流数码-数码配件-存储卡", "电脑手机数码-数码配件-存储卡"],
 ["潮流数码-数码配件-其它配件", "电脑手机数码-数码配件-其他"],
 ["潮流数码-数码配件-闪光灯/手柄", "电脑手机数码-数码摄像-闪光灯"],
 ["潮流数码-数码配件-镜头滤镜", "电脑手机数码-数码摄像-滤镜"],
 ["潮流数码-数码配件-清洁用品", "电脑手机数码-数码配件-相机清洁"],
 ["电脑精品-电脑整机-笔记本电脑", "电脑手机数码-电脑整机-笔记本"],
 ["电脑精品-电脑整机-台式机", "电脑手机数码-电脑整机-台式机"],
 ["电脑精品-电脑整机-上网本", "电脑手机数码-电脑整机-上网本"],
 ["电脑精品-电脑整机-平板电脑", "电脑手机数码-电脑整机-平板电脑"],
 ["电脑精品-外设产品-移动硬盘", "电脑手机数码-电脑外设产品-移动硬盘"],
 ["电脑精品-外设产品-显示器", "电脑手机数码-电脑外设产品-显示器"],
 ["电脑精品-外设产品-键盘/鼠标", "电脑手机数码-电脑外设产品-键盘"],
 ["电脑精品-笔记本配件-其他周边", "电脑手机数码-电脑整机-笔记本配件"],
 ["精品百货-精美礼品-精美礼品", "其他-礼品/礼物-时尚礼品"],
 ["精品百货-品牌手表-商务腕表", "珠宝配饰-手表钟表-时尚品牌"],
 ["精品百货-品牌手表-运动腕表", "珠宝配饰-手表钟表-其他表"],
 ["精品百货-品牌手表-时尚腕表", "珠宝配饰-手表钟表-时尚品牌"],
 ["精品百货-品牌手表-情侣对表", "珠宝配饰-手表钟表-其他表"],
 ["精品百货-精美饰品-钻石饰品", "珠宝配饰-钻石珠宝-钻石饰品"],
 ["精品百货-精美饰品-黄金饰品", "珠宝配饰-金银首饰-黄金铂金"],
 ["精品百货-精美饰品-水晶饰品", "珠宝配饰-翡翠琥珀-水晶饰品"],
 ["精品百货-精美饰品-翡翠玉石", "珠宝配饰-翡翠琥珀-翡翠玉石"],
 ["精品百货-精美饰品-纯银饰品", "珠宝配饰-金银首饰-纯银饰品"],
 ["精品百货-家居生活-家居用品", "家居家纺-家纺-其他"],
 ["精品百货-运动专区-户外自行车", "运动户外-运动名品-骑行用品"],
 ["精品百货-运动专区-户外装备", "运动户外-户外装备-刀具/工具"],
 ["精品百货-家用电器-厨房电器", "家电/办公-厨房家电-其他"],
 ["精品百货-礼品收藏-进口红酒", "其他-礼品/礼物-其他礼品"],
 ["精品百货-礼品收藏-金条银条", "其他-礼品/礼物-其他礼品"]
    ]
    def title
      doc.css("span#ctl00_contentBody_lblProductName/text()").text
    end

    def price
      doc.css("span#ctl00_contentBody_lblYiDianDaPrice/text()").text
    end

    def price_url
    end

    def stock
      1
    end

    def image_url
      doc.css("div.showBigPic img").first["src"]
    end

    def score
    end

    def desc
    end

    def standard
     # doc.css(".paraDetail").to_html
    end

    def comments
      #http://club.360buy.com/clubservice/productcomment-495087-5-0.+html
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
      get_merchant("一点达")

    end

    def brand
    end

    def brand_type
    end
    
    # 商品代码
    def product_code
    end
    
    def belongs_to_categories
      product_page_category_url = product.page.category.url
      product_page_category_url_code = product_page_category_url.split("?Category=").last
      if ["93","95","219","365"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Phone.aspx"
        top_name = "手机通讯"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=86"
        middle_name = "手机"   
      elsif ["96","97","98","99","209","220","275","276"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Phone.aspx"
        top_name = "手机通讯"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=210"
        middle_name = "手机配件"   
      elsif ["357","358"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Phone.aspx"
        top_name = "手机通讯"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=356"
        middle_name = "北京电信"   
      elsif ["122","123","125","305"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Computer.aspx"
        top_name = "电脑精品"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=89"
        middle_name = "电脑整机"   
      elsif ["116","180","292"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Computer.aspx"
        top_name = "电脑精品"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=90"
        middle_name = "外设产品"   
      elsif ["284"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Computer.aspx"
        top_name = "电脑精品"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=225"
        middle_name = "笔记本配件"   

      elsif ["100","101","102"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/digital.aspx"
        top_name = "潮流数码"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=87"
        middle_name = "数码影像"   
      elsif ["113","114","119","120","207","231","279","353"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/digital.aspx"
        top_name = "潮流数码"      

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=88"
        middle_name = "数码影音"   
      elsif ["108","110","117","175","270","271","273"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/digital.aspx"
        top_name = "潮流数码"   

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=202"
        middle_name = "数码配件"   



      elsif ["236","249","250","251"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Commodity.aspx"
        top_name = "精品百货"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=235"
        middle_name = "品牌手表"   
      elsif ["111"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Commodity.aspx"
        top_name = "精品百货"       

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=239"
        middle_name = "家居生活"   
      elsif ["252","253","254","255","256"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Commodity.aspx"
        top_name = "精品百货"   

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=237"
        middle_name = "精美饰品"   


      elsif ["217","266"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Commodity.aspx"
        top_name = "精品百货"     

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=247"
        middle_name = "运动专区"   
      elsif ["361"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Commodity.aspx"
        top_name = "精品百货"        

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=360"
        middle_name = "家用电器"   
      elsif ["363","364"].include?(product_page_category_url_code)
         top_url = "http://www.yidianda.com/Commodity.aspx"
        top_name = "精品百货"   

         middle_url = "http://www.yidianda.com/C2Category.aspx?Category=362"
        middle_name = "礼品收藏"   
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
    end
    
  end
end
