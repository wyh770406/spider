#encoding: utf-8
require "nokogiri"
module Spider
  class TuniuhotelDigger < Digger
    attr_reader :url, :doc
	
	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
	end

	def product_list
          doc.css(".list-infoL dl h2 a").map{|elem| "http://hotel.tuniu.com"+elem["href"]}
	end
  end
end
