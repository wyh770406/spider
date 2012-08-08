# encoding: utf-8
require 'nokogiri'
module Spider
  class MengbashaDigger < Digger
    attr_reader :url, :doc
    
    def initialize(page)
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      p_url = url.match(/http:\/\/[\w]+.moonbasa.com/).to_a.first
      doc.css("div.plist/dl/dt/a").map{|elem| p_url + elem["href"]}
    end

  end
end
