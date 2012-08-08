# encoding: utf-8
require "nokogiri"
module Spider
  class Pb89Digger < Digger
    attr_reader :url, :doc

	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
	end
    
	def product_list
      base_url = "http://www.pb89.com"
	  doc.css("p.product-msg a").map{|elem| [base_url, elem["href"]].join}	
	end
  end

end
