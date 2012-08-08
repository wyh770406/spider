# encoding: utf-8
require 'nokogiri'
module Spider
	class	AmazonbookPaginater < Paginater
		attr_reader :doc, :url
		
		def initialize(item)
      @url = item.url 
      @doc = Nokogiri::HTML(item.html)
		end

		def pagination_list
			num_elem = doc.css(".resultCount")
			if num_elem.blank?
				page_num = 1
			else
				total = num_elem.text.match(/([\d,]+).$/)[1].delete(',').to_i
				puts "total: #{total}"
				per_page = num_elem.text.match(/-(\d+)/)[1].to_i
				puts "per_page: #{per_page}"
				page_num = total/per_page
				page_num += 1 if total%per_page != 0
				puts "page_num: #{page_num}"
			end

                         page_num=401 if page_num>400 
                           
			(0...page_num).map do |index|
				r_u = url.gsub(/page=1/, "page=#{index+1}")
				r_u = doc.css(".pagnLink a")[0][:href].gsub(/page=\d/, "page=#{index+1}") if $~.nil?
				r_u
			end
		end
	end
end
