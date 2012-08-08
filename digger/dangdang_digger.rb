# encoding: utf-8
require 'nokogiri'
module Spider
  class DangdangDigger < Digger
    attr_reader :url, :doc

    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list
      doc.css(".resultlist p.title[name= 'Name'] a").map{|elem| elem["href"]} if doc.css(".resultlist p.title[name= 'Name'] a")!=""
      doc.css(".mode_goods div.name/a").map{|elem| elem["href"]} if doc.css(".mode_goods div.name/a")!=""
    end

  end
end
