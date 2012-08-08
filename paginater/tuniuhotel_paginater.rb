# encoding: utf-8
require 'nokogiri'
module Spider
  class TuniuhotelPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
          puts doc.css("div#list-navR span")[1].text
          puts "ccccvvvvvxxxxxxxx"
          puts url
          max_page = doc.css("div#list-navR span")[1].text.split("/").last.to_i
          return (1..max_page).map{|i| "#{url}/0_1_0_#{i}/"}
    end
    
  end
end
