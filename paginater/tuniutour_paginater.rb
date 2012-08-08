#encoding: utf-8
require 'nokogiri'
module Spider
  class TuniutourPaginater < Paginater
    attr_reader :doc, :url

	def initialize(item)
	  @url = item.url
	  @doc = Nokogiri::HTML(item.html)
	end

	def pagination_list
	  doc.css("div.category_list_inner ul li a").map do |paginator|
		next if (paginator.parent.present? && paginator.parent.parent.present? && paginator.parent.parent.previous_element.present? && paginator.parent.parent.previous_element.text.to_s == "签证办理") || paginator["href"].to_s.include?("youlun")
		paginator["href"].to_s
	  end.compact
	end
  end
end
