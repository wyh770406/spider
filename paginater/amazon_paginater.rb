# encoding: utf-8
require 'nokogiri'
module Spider
	class	AmazonPaginater < Paginater
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

				if num_elem.text.match(/([\d,]+).$/).blank?
          page_num = 1
        else
          total = num_elem.text.match(/([\d,]+).$/)[1].delete(',').to_i if num_elem.text.match(/([\d,]+).$/)

          per_page = num_elem.text.match(/-(\d+)/)[1].to_i if num_elem.text.match(/-(\d+)/)
          puts "per_page: #{per_page}"
          if per_page.nil?
            page_num = 1
          else
            page_num = total/per_page
            page_num += 1 if total%per_page != 0
            puts "page_num: #{page_num}"
          end
        end
			end

			(0...page_num).map do |index|
				r_u = url.gsub(/page=1/, "page=#{index+1}")
				r_u = doc.css(".pagnLink a")[0][:href].gsub(/page=\d/, "page=#{index+1}") if $~.nil? && doc.css(".pagnLink a")[0]
				r_u
			end

		end
	end
end
