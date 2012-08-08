# encoding: utf-8
require 'open-uri'
require 'hpricot'
module Spider
  class TaobaoPaginater < Paginater
    attr_reader :doc, :url

    def initialize(category_link)
      @url = category_link
      html = open(category_link).read 
      html = html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      @doc = Hpricot.parse(html)
    end

    def pagination_list
      max_page = @doc.search("span.page-skip").text[/\d+/, 0].to_i
      (0...max_page).map{|i| "#{@url.split('?').first}?s=#{i * 40}&#{@url.split('?').last}"}
    end
  end
end
