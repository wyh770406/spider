# encoding: utf-8
require 'nokogiri'
module Spider
  class OnecarDigger < Digger
    attr_reader :url, :doc
    BASE_URL = "http://www.1car.com.cn"
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.search("td.tablewhite a.tablewhite[href*='ProductNo=']").map{|elem| File.join(BASE_URL, elem["href"])}
    end

  end
end
