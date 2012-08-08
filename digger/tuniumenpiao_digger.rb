#encoding: utf-8
require "nokogiri"
module Spider
  class TuniumenpiaoDigger < Digger
    attr_reader :url, :doc
	
	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
	end

	def product_list
      doc.css("div.tickets_list_hd h2 a.cgreen").select{|elem| elem["href"] && elem["href"].to_s !~ /area|city/}.map{|elem| "http://menpiao.tuniu.com"+elem["href"]}
	end
  end
end
