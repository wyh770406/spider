# encoding: utf-8
require 'nokogiri'
module Spider
  class BailingkePaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      puts item.url
	  @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
	  num = doc.css("span.f_l b").text.to_i
      max_page = (num/40.to_f).ceil
      (1..max_page).map{|i| url + "&page=#{i}"}
    end
  end
end

