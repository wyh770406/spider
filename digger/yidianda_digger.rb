# encoding: utf-8
require 'nokogiri'
module Spider
  class YidiandaDigger < Digger
    attr_reader :url, :doc
    
    BaseUrl = "http://www.yidianda.com"

    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css("li.listpic a").map{|elem| BaseUrl + elem["href"]}
    end

  end
end
