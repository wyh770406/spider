#encoding: utf-8
require "nokogiri"
module Spider
  class TuniuyoulunDigger < Digger
    attr_reader :url, :doc
	
	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
	end

	def product_list
      doc.css("div.route_intro h3 a.cgreen").map{|elem| elem["href"]}
	end
  end
end
