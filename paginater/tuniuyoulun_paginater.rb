#encoding: utf-8
require 'nokogiri'
module Spider
  class TuniuyoulunPaginater < Paginater
    attr_reader :doc, :url

	def initialize(item)
	  @url = item.url
	  @doc = Nokogiri::HTML(item.html)
	end

	def pagination_list
	puts "111111111111111"

      length = doc.css("a").last.attributes["onclick"].value[/\d+/].to_i
	  puts length
	  max_page = (length.to_f/10).ceil
      return (1..max_page).map{|i| url.split("page=")[0] + "page=" + i.to_s}
	end
  end
end
