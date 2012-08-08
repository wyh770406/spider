# encoding: utf-8
require 'nokogiri'
module Spider
	class DangdangbookDigger < Digger
		attr_reader :url, :doc

		def initialize(page)
			@url = page.url
			@doc = Nokogiri::HTML(page.html)
		end

		def product_list
			doc.css(".tiplist a[name='link_prd_name']").map{|elem| elem["href"]}
      #doc.css("#plist .item .p-name a")
		end

	end
end
