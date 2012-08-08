
# encoding: utf-8
require "nokogiri"
module Spider
  class OkbuyDigger < Digger
    attr_reader :url, :doc

	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
	end

	def product_list
	  base_url = "http://www.okbuy.com"
	  doc.css("div.goodsList li div.img a").map{|elem| [base_url, elem["href"]].join} 
	end
  
  end
end
