#encoding UTF-8
require 'nokogiri'
module Spider
  class VjiaDigger < Digger
    attr_reader :url, :doc, :page
	
	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
          @page = page
	end

	def product_list
	  # 一般情况
	  base_url = "http:\/\/www.vjia.com"
	  product_arry = []
	  product_arry << doc.css("div.cInfoBox div.cName a").map{|elem| elem["href"]}
      # 箱包情况
      #product_arry << doc.css("ul li div.productName a").map{|elem| elem["href"]}
	  product_arry.flatten! 
	end

    def cate_path
      hash_cate_path=[]
      if doc.css(".location")
        hash_cate_path=doc.css(".location a").select{|elem| elem["href"] && elem["href"].to_s =~ /html/}.map do |elem|
          {
            :name => elem.inner_text,
            :url  => "http://www.vjia.com"+elem["href"]
          }
        end

      end

      hash_cate_path << {:name=>page.category.name,:url=>page.category.url}

    end
  end
end
