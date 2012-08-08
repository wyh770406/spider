#encoding: utf-8
require "nokogiri"
module Spider
  class TuniuDigger < Digger
    attr_reader :url, :doc
	
	def initialize(page)
	  @url = page.url
	  @doc = Nokogiri::HTML(page.html)
	end

	def product_list
	  product_arry = []
	  base_url = url.split('com')[0]+'com'

	  product_arry << doc.css("td.cate_route_name a").map{|elem| elem["href"].to_s.include?("http://") ? elem["href"] : [base_url, elem["href"]].join}
 	  # 公司旅游
	  product_arry << doc.css("table.gongsi_list tbody tr td a").map{|elem| [base_url, elem["href"]].join}
      # 酒店
	  product_arry << doc.css("div.hotel_list_headL table tbody tr td a.cgreen").map{|elem| [base_url, elem["href"]].join}
      # 景区门票
	  product_arry << doc.css("dl.quick_nav_list dd a.cgreen").map{|elem| [base_url, elem["href"]].join}
	  # 游轮
	  product_arry << doc.css("div.route_intro h3 a.cgreen").map{|elem| elem["href"]}
	  product_arry.flatten!
	end
  end
end
