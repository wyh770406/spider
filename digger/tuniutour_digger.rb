#encoding: utf-8
require "nokogiri"
module Spider
  class TuniutourDigger < Digger
    attr_reader :url, :doc
	
	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
	end

	def product_list
	  base_url = url.split('com')[0]+'com'
          puts base_url
          puts url
          puts "ddddffffffffffggggggggggggg"
	  doc.css("td.cate_route_name a").map{|elem| (elem["href"].to_s.include?("http://") ? elem["href"] : [base_url, elem["href"]].join) if !elem["href"].include?("static/niuren")}.compact
	end

        def cate_path
          doc.css("#breadcrumb a").select{|elem| elem["href"] && elem["href"].to_s =~ /around|domestic|abroad|gongsi/}.map do |elem|
          {
            :name => elem.inner_text,
            :url  => elem["href"]
          }
        end
        end
  end
end
