# encoding: utf-8
require 'nokogiri'
module Spider
  class YihaodianPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css("li.latestnewtotalpage").text[/\d+/, 0].to_i
      
      if max_page > 1
        num = url.split("/").last[/\d+/, 0].to_i
        (1..max_page).map do |i|
          url.sub(/c-([\W][\w]+)+\/([\d]+).html/, "c#{num}-b0-a-s1-v0-p#{i}-price-d0-f0-k")
        end
      else
        [url]
      end
    end
    
  end
end
