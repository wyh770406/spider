# encoding: utf-8
require 'nokogiri'
module Spider
  class BailingkeDigger < Digger
    attr_reader :url, :doc
    BASE_URL = "http://www.bailingke.com" 
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css("div.goodsItem_s p a[title]").map{|elem| File.join(BASE_URL, elem["href"])}
    end

  end
end
