# encoding: utf-8
require 'nokogiri'
module Spider
  class GuguwangDigger < Digger
    attr_reader :url, :doc
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css("div.goodinfo h6 a[href]").map{|elem| elem["href"]}
    end

  end
end
