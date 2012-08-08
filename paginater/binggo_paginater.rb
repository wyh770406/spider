# encoding: utf-8
require 'nokogiri'
module Spider
  class BinggoPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page_doc = doc.css("span.globalOrderPageText")
      max_page = max_page_doc.last.inner_text.split("/").last.to_i
      return (1..max_page).map{|i| "#{url.chop}p#{i}"}
    end
    
  end
end
