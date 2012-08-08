# encoding: utf-8
require 'nokogiri'
module Spider
  class HcyxbookDigger < Digger
    attr_reader :url, :doc
    BASE_URL = "http://www.hcyxbook.com" 
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css("td a.underline").map{|elem| File.join(BASE_URL, elem["href"])}
    end

  end
end
