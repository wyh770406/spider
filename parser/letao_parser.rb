# encoding: utf-8
require 'nokogiri'

module Spider
  class LetaoParser < Parser
    BaseURL = "http://www.letao.com"
    CATEGORY_MAP = [
      ["女鞋-运动鞋-板鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-靴子", "鞋帽服饰-女鞋-靴子"],
      ["女鞋-运动鞋-跑步鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-篮球鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-休闲鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-户外鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-网球鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-足球鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-训练鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-凉鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
      ["女鞋-运动鞋-拖鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
      ["女鞋-运动鞋-雪地靴", "鞋帽服饰-女鞋-靴子"],
      ["女鞋-运动鞋-徒步鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-运动鞋-登山鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-皮鞋-板鞋", "鞋帽服饰-女鞋-其他款"],
      ["女鞋-皮鞋-休闲皮鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
      ["女鞋-皮鞋-单鞋", "鞋帽服饰-女鞋-单鞋"],
      ["女鞋-皮鞋-靴子", "鞋帽服饰-女鞋-靴子"],
      ["女鞋-皮鞋-休闲鞋", "鞋帽服饰-女鞋-流行休闲鞋"],
      ["女鞋-皮鞋-户外鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-皮鞋-凉鞋", "鞋帽服饰-女鞋-凉鞋 "],
      ["女鞋-皮鞋-凉拖", "鞋帽服饰-女鞋-凉拖/拖鞋"],
      ["女鞋-皮鞋-拖鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
      ["女鞋-皮鞋-雪地靴", "鞋帽服饰-女鞋-靴子"],
      ["女鞋-布鞋-布鞋", "鞋帽服饰-女鞋-其他款"],
      ["女鞋-布鞋-拖鞋", "鞋帽服饰-女鞋-凉拖/拖鞋"],
      ["女鞋-户外鞋-靴子", "鞋帽服饰-女鞋-靴子"],
      ["女鞋-户外鞋-跑步鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-户外鞋-休闲鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-户外鞋-户外鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-户外鞋-凉鞋", "鞋帽服饰-女鞋-凉鞋 "],
      ["女鞋-户外鞋-雪地靴", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-户外鞋-徒步鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-户外鞋-登山鞋", "鞋帽服饰-女鞋-运动休闲鞋"],
      ["女鞋-袜子", "鞋帽服饰-服饰配饰-袜子"],
      ["男鞋-运动鞋-板鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["男鞋-运动鞋-跑步鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-篮球鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-休闲鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-网球鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-户外鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-足球鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-训练鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-凉鞋", "鞋帽服饰-男鞋-凉鞋"],
      ["男鞋-运动鞋-拖鞋", "鞋帽服饰-男鞋-凉拖/拖鞋"],
      ["男鞋-运动鞋-雪地靴", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-徒步鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-运动鞋-登山鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-皮鞋-商务皮鞋", "鞋帽服饰-男鞋-商务休闲鞋"],
      ["男鞋-皮鞋-休闲皮鞋", "鞋帽服饰-男鞋-商务休闲鞋"],
      ["男鞋-皮鞋-靴子", "鞋帽服饰-男鞋-靴子"],
      ["男鞋-皮鞋-休闲鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["男鞋-皮鞋-户外鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["男鞋-皮鞋-凉鞋", "鞋帽服饰-男鞋-凉鞋"],
      ["男鞋-皮鞋-拖鞋", "鞋帽服饰-男鞋-其他款鞋帽服饰-男鞋-凉拖/拖鞋"],
      ["男鞋-皮鞋-雪地靴", "鞋帽服饰-男鞋-靴子"],
      ["男鞋-布鞋-休闲皮鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["男鞋-布鞋-布鞋", "鞋帽服饰-男鞋-其他款"],
      ["男鞋-布鞋-拖鞋", "鞋帽服饰-男鞋-凉拖/拖鞋"],
      ["男鞋-户外鞋-板鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-户外鞋-靴子", "鞋帽服饰-男鞋-靴子"],
      ["男鞋-户外鞋-跑步鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-户外鞋-休闲鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["男鞋-户外鞋-户外鞋", "鞋帽服饰-男鞋-户外休闲鞋"],
      ["男鞋-户外鞋-凉鞋", "鞋帽服饰-男鞋-凉鞋"],
      ["男鞋-户外鞋-拖鞋", "鞋帽服饰-男鞋-凉拖/拖鞋"],
      ["男鞋-户外鞋-雪地靴", "鞋帽服饰-男鞋-靴子"],
      ["男鞋-户外鞋-徒步鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-户外鞋-登山鞋", "鞋帽服饰-男鞋-运动休闲鞋"],
      ["男鞋-袜子", "鞋帽服饰-服饰配饰-袜子"],
      ["儿童鞋-运动鞋-板鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-靴子", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-跑步鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-篮球鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-休闲鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-网球鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-户外鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-足球鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-训练鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-凉鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-运动鞋-雪地靴", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-皮鞋-单鞋", "鞋帽服饰-童鞋-其他款"],
      ["儿童鞋-皮鞋-靴子", "鞋帽服饰-童鞋-其他款"],
      ["儿童鞋-皮鞋-休闲鞋", "鞋帽服饰-童鞋-便鞋"],
      ["儿童鞋-皮鞋-凉鞋", "鞋帽服饰-童鞋-凉鞋"],
      ["儿童鞋-户外鞋-靴子", "鞋帽服饰-童鞋-其他款"],
      ["儿童鞋-户外鞋-跑步鞋", "鞋帽服饰-童鞋-运动鞋"],
      ["儿童鞋-户外鞋-休闲鞋", "鞋帽服饰-童鞋-其他款"],
      ["儿童鞋-户外鞋-户外鞋", "鞋帽服饰-童鞋-其他款"]
    ]
    def title
      doc.css("div#buyinfo h1").text
    end

    def price
      doc.css(".ltprice.big").text.gsub(/元/,"").strip.to_f#.match(/\d+/).to_f
    end

    def stock
      return 1
    end

    def image_url
      puts product.url
      img = doc.css(".bigshoeimg img").first["lazyload"]
    end

    def desc
    end

    def price_url
    end

    def score
      1
    end
    # 商品代码
    def product_code
    end

    def standard
    end

    def comments
      content_elems    = doc.css("#cmcontent .cmask")
      publish_at_elems = doc.css("#cmcontent .cminfo")
      (0...content_elems.count).map do |i|
        {
          :content    => content_elems[i].inner_text,
          :publish_at => publish_at_elems[i].inner_text.empty? ? Time.now : Time.parse(publish_at_elems[i].inner_text.match(/20\d\d\/.+$/)[0]),
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
      get_merchant("乐淘")
    end

    def brand
    end

    def brand_type
    end

    def get_union_url
      product.url+"?source=findbest"
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

    def belongs_to_categories
      #      doc.css("#ltlinknav a").map do |elem|
      #        {
      #          :name => elem.inner_text,
      #          :url  => URI.escape(File.join(BaseURL, elem["href"]))
      #        }
      #      end
      product_page_category_url = product.page.category.url


      if product_page_category_url.index("woman")
        top_url = "http://www.letao.com/shoe-a-0-a-a-a-a-a-a-n~woman"
        top_name = "女鞋"

      elsif product_page_category_url.index("man")
        top_url = "http://www.letao.com/shoe-a-1-a-a-a-a-a-a-n~man"
        top_name = "男鞋"
      elsif product_page_category_url.index("kid")
        top_url = "http://www.letao.com/shoe-a-3-a-a-a-a-a-a-n~kid"
        top_name = "儿童鞋"
      end

      if product_page_category_url.match(/shoe-3.*woman/)
        middle_url = "http://www.letao.com/shoe-3-0-a-a-a-a-a-a-n~woman"
        middle_name = "运动鞋"
      elsif product_page_category_url.match(/shoe-3.*man/)
        middle_url = "http://www.letao.com/shoe-3-1-a-a-a-a-a-a-n~man"
        middle_name = "运动鞋"
      elsif product_page_category_url.match(/shoe-4.*woman/)
        middle_url = "http://www.letao.com/shoe-4-0-a-a-a-a-a-a-n~woman"
        middle_name = "皮鞋"
      elsif product_page_category_url.match(/shoe-4.*man/)
        middle_url = "http://www.letao.com/shoe-4-1-a-a-a-a-a-a-n~man"
        middle_name = "皮鞋"
      elsif product_page_category_url.match(/shoe-5.*woman/)
        middle_url = "http://www.letao.com/shoe-5-0-a-a-a-a-a-a-n~woman"
        middle_name = "布鞋"
      elsif product_page_category_url.match(/shoe-5.*man/)
        middle_url = "http://www.letao.com/shoe-5-1-a-a-a-a-a-a-n~man"
        middle_name = "布鞋"
      elsif product_page_category_url.match(/shoe-6.*woman/)
        middle_url = "http://www.letao.com/shoe-6-0-a-a-a-a-a-a-n~woman"
        middle_name = "户外鞋"
      elsif product_page_category_url.match(/shoe-6.*man/)
        middle_url = "http://www.letao.com/shoe-6-1-a-a-a-a-a-a-n~man"
        middle_name = "户外鞋"
      elsif product_page_category_url.match(/shoe-3.*kid/)
        middle_url = "http://www.letao.com/shoe-3-3-a-a-a-a-a-a-n~kid"
        middle_name = "运动鞋"
      elsif product_page_category_url.match(/shoe-4.*kid/)
        middle_url = "http://www.letao.com/shoe-4-3-a-a-a-a-a-a-n~kid"
        middle_name = "皮鞋"
      elsif product_page_category_url.match(/shoe-6.*kid/)
        middle_url = "http://www.letao.com/shoe-6-3-a-a-a-a-a-a-n~kid"
        middle_name = "户外鞋"
      end
      if product_page_category_url.match(/shoe-7/)#product.page.category.name == "袜子"
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
      else
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
end
