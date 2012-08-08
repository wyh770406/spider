# encoding: utf-8
require 'nokogiri'
module Spider
	class	RedbabyPaginater < Paginater
		attr_reader :doc, :url
		
		def initialize(item)
      @url = item.url 
      @doc = Nokogiri::HTML(item.html)
		end

		def pagination_list
      max_page = doc.css('.globalPage a').map{|elem| elem.inner_text.to_i}.max || 1 # => 找不到 ".globalPage a"的情况为 只有 1页
			(0...max_page).map do |index|
				url.sub(/\/$/, "p#{index+1}\/")	
			end
		end
	end
end
