# encoding: utf-8
require 'nokogiri'
module Spider
  class WinxuanPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page_doc = doc.css("div.com_pages span.fr")
      max_page = max_page_doc.text.split("/").last[/\d+/].to_i
      return (1..max_page).map{|i| "#{url}?page=#{i}"}
    end
    
  end
end
