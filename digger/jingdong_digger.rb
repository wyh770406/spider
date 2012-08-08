# encoding: utf-8
require 'nokogiri'
module Spider
  class JingdongDigger < Digger
    attr_reader :url, :doc

    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css("#plist ul.list-h div.p-img a").map{|elem| elem["href"]}
    end

  end
end
