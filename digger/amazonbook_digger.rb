# encoding: utf-8
require 'nokogiri'
module Spider
	class AmazonbookDigger < Digger
		attr_reader :url, :doc, :page

		def initialize(page)
                        @page = page
			@url = page.url
			@doc = Nokogiri::HTML(page.html)
		end

		def product_list
			item = doc.css(".dataColumn tr:nth-child(1) a")
			return item.map{|elem| elem["href"]} if item.present?
			item = doc.css(".product div.image a")
			return item.map{|elem| elem["href"]} if item.present?
		end

		def cate_path
                   hash_cate_path=[]
			cate_path_num = doc.css("#breadCrumb a").size
			hash_cate_path=(0...cate_path_num).map do |index|
				{
					:name => doc.css("#breadCrumb a")[index].text,
					:url => "http://www.amazon.cn"+doc.css("#breadCrumb a")[index][:href]
				}
			end
		    hash_cate_path << {:name=>page.category.name,:url=>page.category.url}
                end

	end
end
