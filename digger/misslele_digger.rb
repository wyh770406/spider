# encoding: utf-8
require 'nokogiri'
module Spider
  class MissleleDigger < Digger
    attr_reader :url, :doc
    BaseURL = "http://www.misslele.com/"

    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css("div.firstlist ul li a").map{|elem| BaseURL + elem["href"]}
    end

  end
end
