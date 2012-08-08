# encoding: utf-8
require 'nokogiri'
module Spider
  class TmallDigger < Digger
    attr_reader :url, :doc, :page

    def initialize(page)
      @page = page
      @url = page.url
      @doc = Nokogiri::HTML(page.html)
    end

    def product_list 
      doc.css(".product a").map{|elem| elem["href"]}
    end

    def cate_path
      hash_cate_path=[]
      if doc.css(".mallCrumbs-nav")
        hash_cate_path=doc.css(".mallCrumbs-nav a").select{|elem| elem["href"] && elem["href"].to_s =~ /cat=/}.map do |elem|
          {
            :name => elem.inner_text,
            :url  => elem["href"]
          }
        end

      end

      hash_cate_path << {:name=>page.category.name,:url=>page.category.url}

    end
  end
end
