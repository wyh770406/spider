# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class UbaoFetcher < Fetcher
    URL = "http://www.ubao.com"

    def self.category_list
      html = open(URL).read
      doc = Nokogiri::HTML(html)
      doc.css(".item a[href^='/']").select{|elem| elem[:href] != "/sp/p8"}.map do |e|
        {
          :url => File.join(URL, e[:href]),
          :name => e.inner_text.strip
        }
      end
      
    end
    
  end
end
