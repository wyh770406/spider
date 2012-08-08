# encoding: utf-8
require 'nokogiri'
module Spider
  class UbaoPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      return [url]
    end
    
  end
end
