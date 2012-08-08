# encoding: utf-8
require 'open-uri'
require 'hpricot'
require 'json'

module Spider
  class TaobaoParser < Parser
    attr_reader :url, :doc

    def initialize(product_url)
      @url = product_url
      @html = open(@url).read
      @html = @html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      @doc = Hpricot.parse(@html)
    end
    
    # 商品名称
    def title
      @doc.search("div#detail div.tb-detail-hd h3/*").inner_text
    end
    
    # 市场价
    def price
      price_elem = @doc.search("strong#J_StrPrice")
      price_elem.inner_text.match(/\d+.\d+/).to_s.to_i if !price_elem.nil? and !price_elem.empty?
    end
  
    # 库存
    def stock
      @doc.search('#J_SpanStock').inner_text.to_i
    end
    
    # 已售出
    def sold
      @doc.search('.tb-sold-out em').inner_text.to_i
    end

    # 运费
    def freight
      freight_elem = @doc.search("#ShippingCost em")
      freight_elem.inner_text.match(/\d+.\r+/).to_s.to_i if !freight_elem.nil? and !freight_elem.empty?
    end

    #	所在地区
    def location_area
      location_area_elem = @doc.search("ul.tb-other li")
      return location_area_elem.first.search("em").inner_text if !location_area_elem.nil? and !location_area_elem.empty?
      location_area_elem = @doc.search(".locus")
      location_area_elem.first.children.last.inner_text if !location_area_elem.nil? and !location_area_elem.empty?
    end

    # 规格
    def attributes
      @doc.search("div#attributes ul.attributes-list li").map do |attribute|
	{
	  :name => attribute.inner_text.split(/:|：/).first,
	  :value => attribute.attributes['title']
	}
      end
    end
		
    # 商品图片
    def image_url
      @doc.search("#J_ImgBooth").attr('src')
    end

    def comments
      comment_list_url = @doc.search("#reviews").attr('data-reviewapi')
      return if comment_list_url.nil? or comment_list_url.empty?
      comment_list_html = open(comment_list_url).read
      comment_list_html = comment_list_html.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
      star_elem_html = comment_list_html[/scoreInfo\":\r\n(.*)\r\n,\"scoreJsonInfo/m, 1]
      star_hash =  JSON.parse(star_elem_html)
      star = star_hash['merchandisScore'].to_f || 0
      comment_elems_html = comment_list_html[/\[(.*?)\]/m, 1]
      comment_elems = comment_elems_html.split(/},{|}, {/)
      i = 1
      comments = comment_elems.map do |elem|
	if i == 1
	  elem = elem + '}'
	elsif i == comment_elems.length
	  elem = '{' + elem
	else
	  elem = '{' + elem + '}'
	end
	i += 1
	elem_hash = JSON.parse(elem)
	{
	  :title => elem_hash['auctionSku'],
	  :content => elem_hash['rateContent'],
	  :publish_at => elem_hash['rateDate'],
	  :star => star
	}
      end
    end

  end
end
