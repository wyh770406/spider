# encoding: utf-8
require 'open-uri'
require 'nokogiri'


module Spider
  class LetaoFetcher < Fetcher
    URL = "http://www.letao.com/brand"
    BaseCatURL = "http://www.letao.com/brand"
    BaseURL = "http://www.letao.com"
    

    def self.category_list
      html = open(URL).read
      html = html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
      doc = Nokogiri::HTML(html)
      cate_arr = []
      doc.css("a[@lt_stat_id ^='brandpage_tab']").each do |nav_elem|
        # get the six category()
	car_url = BaseCatURL + nav_elem["href"]
        # women men sport 
        if nav_elem["href"].include?("brand?tid")
	 pair = "a[@lt_stat_id ^='brandpage_/']"
         cate_arr.concat(self.get_each_category_list(car_url, pair))
        end
      end
     cate_arr
    end
    
    def self.get_each_category_list(car_url, pair)
       car_html = open(car_url).read
       car_html = car_html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?") 
       car_doc = Nokogiri::HTML(car_html)
       car_doc.css("#{pair}").map do |elem|
       {
	  :name => elem["title"],
	  :url => URI.escape(File.join(BaseURL, elem["href"]))
       }
       end
   end

   
   

  end
end


