# encoding: utf-8
require 'nokogiri'
module Spider
  class JingdongbookPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
			paginate_doc = doc.css(".pagin.pagin-m a")
      max_page = paginate_doc.map{|elem| elem.children.text.to_i}.max || 1
      (1..max_page).map{|i| url.sub(".html", "-0-0-0-0-0-0-0-1-1-#{i}.html")}
    end
  end
end
