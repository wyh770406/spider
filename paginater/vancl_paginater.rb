# encoding: utf-8
require 'nokogiri'
module Spider
  class VanclPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css("div.pagediv span").first.text.split("/").last.to_i
      
      (1..max_page).map do |i|
        url+"?p=#{i}"
        #url.sub(".html", "?p=#{i}")
      end
    end
    
  end
end
