# encoding: utf-8
require 'nokogiri'
module Spider
  class GuguwangPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css("span.pageall").first.text.to_i
	  category_num = url[/\d+/]
      return (1..max_page).map{|i| "http://www.guguwang.com/gallery-#{category_num}--0--#{i}--grid.html"}
    end
    
  end
end
