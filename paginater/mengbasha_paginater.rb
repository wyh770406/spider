# encoding: utf-8
require 'nokogiri'
module Spider
  class MengbashaPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css(".border_bottom a").map{|elem| elem.text.to_i}.max || 1
      url_arr = url.split("-")
      (1..max_page).map{|i| "#{url_arr[0]}-#{i}-40-0.html"}
    end
  end
end
