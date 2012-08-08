# encoding: utf-8
require 'nokogiri'
module Spider
  class MartDigger < Digger
    attr_reader :url, :doc

    BaseUrl = "http://www.360mart.com"
    
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css(".pho a").map{|elem| BaseUrl + elem["href"]}
    end

  end
end
