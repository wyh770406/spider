# encoding: utf-8
require 'open-uri'
require 'hpricot'

module Spider
  class TaobaoDigger < Digger
    attr_reader :url, :doc

    def initialize(pagination_link)
      @url = pagination_link
      html = open(pagination_link).read 
      html = html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      @doc = Hpricot.parse(html)
    end
    
    def product_list 
      doc.search("#J_ListView li.list-item").map {|product| product.search("h3.title/a").attr("href")}
    end

  end
end
