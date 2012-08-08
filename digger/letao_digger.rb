# encoding: utf-8
require 'nokogiri'
module Spider
  class LetaoDigger < Digger
    attr_reader :url, :doc
    BaseURL = "http://www.letao.com"
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list
      #doc.search("div.pic a").map{|elem| elem["href"]}.gsub(/[^\w]*$/, '')

      doc.css("div#prodlist a").map{|elem| 
        if elem["href"]=~ /[\u4e00-\u9fa5]/
        "http://www.letao.com"+elem["href"][0,elem["href"]=~ /[\u4e00-\u9fa5]/]
        else
        "http://www.letao.com"+elem["href"]
        end}
    end

  end
end
