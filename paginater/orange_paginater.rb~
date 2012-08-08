# encoding: utf-8
require 'nokogiri'
module Spider
  class OrangePaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      element = doc.css("span.pageall")
      if element.present?
        max_page = element.text.to_i
      
        (1..max_page).map do |i|
          num = url.scan(/\d+/)
          url.sub(/\/\w+-\d+-grid.html/, "/gallery-#{num.last}--0--#{i}--grid.html")
        end
      else
        [url]
      end
    end
    
  end
end
