# encoding: utf-8
require 'open-uri'
require 'nokogiri'

module Spider
  class WinxuanFetcher < Fetcher
		URL_BOOK = "http://www.winxuan.com/catalog_book.html"
    URL_MEDIA = "http://www.winxuan.com/catalog_media.html"
    URL_MALL = "http://www.winxuan.com/catalog_mall.html"

    def self.category_list
      # the category of book
      html_book = open(URL_BOOK).read
      html_book = html_book.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
     

		 	# the catalogry of media
      html_media = open(URL_MEDIA).read
      html_media = html_media.force_encoding("GB18030").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
 			# the catalogry of mall
      html_mall = open(URL_MALL).read
      html_mall = html_mall.force_encoding("GB18030").encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
 			#doc = Nokogiri::HTML(html_book +  html_media + html_mall)
			
      doc_book = Nokogiri::HTML(html_book)
      
      cate_arr = []
      doc_book.css("div.all_cate dt a").map do |elem|
        if elem["href"] != "http://search.winxuan.com/search?name=%E5%8E%9F%E7%89%88%E4%B9%A6&code=1"
        	inner_url_book = elem["href"]
     			cate_arr.concat(get_each_category_list(elem["href"]))
        end
      end
			cate_arr
    end

			def self.get_each_category_list(car_url)
       car_html = open(car_url).read
       car_html = car_html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
       car_doc = Nokogiri::HTML(car_html)
       car_doc.css("dl.library_catalog dd a").map do |elem|
       {
	  		:name => elem.inner_text,
	  		:url => elem["href"]
       }
       end
   	end

  end
end
