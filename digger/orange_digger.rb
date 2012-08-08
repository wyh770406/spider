# encoding: utf-8
require 'nokogiri'
module Spider
  class OrangeDigger < Digger
    attr_reader :url, :doc

    BaseUrl = "http://www.orange3c.com/"
    
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css(".goodpic a").map{|elem| BaseUrl + elem["href"]}
    end

  end
end
