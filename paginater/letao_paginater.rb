# encoding: utf-8
require 'nokogiri'
module Spider
  class LetaoPaginater < Paginater
    attr_reader :doc, :url
    #Other_urls_1 = ["http://www.letao.com/redstraw-hat-a-0-a-a-a-a-a-a"]
    #Other_urls_2 = ["http://www.letao.com/montagut-4-1-a-a-a-a-a-a-n~manleather"]

    def initialize(item)      
			@url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      max_page_doc = doc.css("#pageupper span").inner_text
      puts max_page_doc
      if max_page_doc.present?
        max_page = max_page_doc.split("/").last.to_i
#        if LetaoPaginater::Other_urls_2.include?(url)http://www.letao.com/shoe-3-0-18-a-a-a-a-a-p3-n~woman
#         return (1..max_page).map{|i| "http://www.letao.com/montagut-4-1-a-a-a-a-a-a-p#{i}-n~manleather"}
#        end
        front_url = url.split("-n").first
        end_url = url.split("-n").last
        return (1..max_page).map{|i| "#{front_url}-p#{i}-n#{end_url}"}
      end
      return []
    end

  end
end
