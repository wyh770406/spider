# encoding: utf-8
require 'nokogiri'
module Spider
  class TuniumenpiaoPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css("div#page_box span").text.split("/").last.to_i
      return (1..max_page).map{|i| "#{url}/0_0_#{i}/"}
    end
    
  end
end
