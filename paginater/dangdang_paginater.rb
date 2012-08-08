# encoding: utf-8
require 'nokogiri'
module Spider
  class DangdangPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css("#all_num").text[/\d+/, 0].to_i
      (1..max_page).map{|i| "#{url}&p=#{i}"}
    end
  end
end
