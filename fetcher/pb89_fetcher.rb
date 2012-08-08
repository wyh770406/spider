# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class Pb89Fetcher < Fetcher
    URL = "http://www.pb89.com"
	 
	def self.category_list
	  html = open(URL).read
	  list = []
	  doc = Nokogiri::HTML(html)
	  doc.css("#head_nav li a").each do |category|
	    if category.next_element.present?
	      category_url = File.join(URL, category["href"]).to_s
          second_html = open(category_url).read
		  second_doc = Nokogiri::HTML(second_html)
		  second_doc.css("div.left_box dl").each do |small_category|
		    #如果没有小分类,就用大的
			dt = small_category.css("dt a")[0]
			dd = small_category.css("dd a")
			if dt.present? && dd.blank?
			  list << {
				  :url => File.join(URL, dt["href"].gsub("/id","")).to_s,
				  :name => dt.inner_text.strip.split("TOPS")[0]
				  }
			else
			  list.concat(dd.map do |element|
			    {
				  :url => File.join(URL, element["href"].gsub("/id","")).to_s,
				  :name => element.inner_text.strip.split("(")[0]
				}
			  end.compact)
			end
		  end
		end
      end
	  return [list].flatten
    end
  end
end
