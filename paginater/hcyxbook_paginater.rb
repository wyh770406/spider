# encoding: utf-8
require 'nokogiri'
module Spider
  class HcyxbookPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
	  text = doc.css("form p.contents font.contents").text
	  return [] if text.blank?
      max_page = doc.css("form p.contents font.contents").select{|elem| elem.text=~ /\//}[0].text[/\d+/].to_i#text[/\/\d/][/\d+/].to_i
      (1..max_page).map{|i| url + "&page=#{i}"}
    end
  end
end

