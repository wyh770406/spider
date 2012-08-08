# encoding: utf-8
require 'nokogiri'
module Spider
  class OnecarPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css("td.tablewhite").last.text.split("共")[1].split("页")[0][/\d+/].to_i
      return (1..max_page).map{|i| "#{url}&Page=#{i}"}
    end
    
  end
end
