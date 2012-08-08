# encoding: utf-8
require 'nokogiri'
module Spider
  class UbaoDigger < Digger
    attr_reader :url, :doc
    BASE_URL = "http://www.ubao.com"
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      arr = doc.css(".adet").map{|elem| File.join(BASE_URL, elem["href"])}
      return arr
    end

  end
end
