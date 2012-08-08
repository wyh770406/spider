# encoding: utf-8
require 'nokogiri'
require 'uri'
require File.expand_path(File.dirname(__FILE__) + "/../utils/utils")

module Spider
  class TmallPaginater < Paginater
    attr_reader :doc, :url

    def initialize(item)
      @url = item.url
      @doc = Nokogiri::HTML(item.html)
    end

    def pagination_list
      #TODO
      #doc.css("#jumpto").first.attr("tpage").to_i if doc.css("#jumpto").first
      p doc.css("li.quick-page-changer span")
      max_page  = doc.css("#totalPage").first.attr("value").to_i
      first_url = doc.css("#filterPageForm").attr("action").to_s
      uri  = URI.parse(first_url)
      hash = Utils.query2hash(uri.query)
      (1..max_page).map do |i|
        uri.query = Utils.hash2query(hash.merge("s" => hash["n"].to_i * (i - 1)))
        uri.to_s
      end
    end
  end
end