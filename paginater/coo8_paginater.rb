# encoding: utf-8
require 'nokogiri'
module Spider
  class Coo8Paginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page = doc.css("div.pageInfo em").last.inner_text.to_i
      
      if max_page >= 2 
      (2..max_page).map do |i|
        s_url = url.split("-")
        if s_url.size == 5
          s_url[-1] = "#{i}-101101.html"
        else
          s_url[-2] = i
          s_url.last.sub!(".html", "-101101.html")  
        end
        
        url = s_url.join("-")
      end
      else
        return [url]
      end
    end
  end
end
