# encoding: utf-8
require 'nokogiri'
module Spider
	class AmazonDigger < Digger
		attr_reader :url, :doc

		def initialize(page)
			@url = page.url
			@doc = Nokogiri::HTML(page.html)
		end

		def product_list
			item = doc.css(".dataColumn tr:nth-child(1) a")
			return item.map{|elem| elem["href"]} if item.present?
			item = doc.css(".product div a")
			return item.map{|elem| elem["href"]} if item.present?
		end

		#def cate_path
		#	cate_path_num = doc.css(".breadCrumb a").size
		#	(0...cate_path_num).map do |index|
		#		{
		#			:name => doc.css(".breadCrumb a")[index].text,
		#			:url => doc.css(".breadCrumb a")[index][:href]
		#		}
		#	end
		#end

	end
end
