# encoding: utf-8
require 'nokogiri'
module Spider
  class MartPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css(".pr a").map{|elem| elem.inner_text.to_i}.max
      
      if max_page > 1
        (1..max_page).map do |i|
          c_num = url.scan(/\d+/)
          url.sub(/\/product\/(\d+)-(\d+)-(\d+).html/, "/goods/goodsList.aspx?subid=#{c_num[1]}%2c#{c_num[2]}%2c#{c_num[3]}&start=#{i}")
        end
      else
        [url]
      end
    end
    
  end
end
