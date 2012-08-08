# encoding: utf-8
require 'nokogiri'

module Spider

  class JingdongbookParser < Parser

    def end_product
    end

    def merchant

    end

    def brand
    end

    def brand_type
    end

    def product_code
    end
    
    def title
      doc.css("div#name h1").text
    end

    def price
			#price_doc = doc.css('.price')
			#return price_doc.text.match(/[\d|\.]+$/).to_s.to_f if price_doc.present?
    end
    
    def price_url
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
			10000000
		end
    
    def score
			#doc.css("div[id^=star] div:first").first["class"].gsub(/[\D]+/, "").to_i
    end
    
    def standard
    end

    def desc
      desc_doc = doc.css(".mc .con")[0]
			return desc_doc.inner_text if desc_doc.present?
			return ''
    end
    
		def comments
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
