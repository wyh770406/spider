# encoding: utf-8
require 'nokogiri'
module Spider
	class RedbabyDigger < Digger
		attr_reader :url, :doc

		def initialize(page)
			@url = page.url
			@doc = Nokogiri::HTML(page.html)
		end

		def product_list
			doc.css(".globalProductName a").map{|elem| elem["href"]}
		end

	end
end
