# encoding: utf-8
require 'nokogiri'
module Spider
  class NeweggDigger < Digger
    attr_reader :url, :doc

    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css("#itemGrid1 div.itemCell  dt/a").map{|elem| elem["href"]}
    end
  end
end

