# encoding: utf-8
module Spider
  module Encoding

    Map = {
      "dangdang"  => "GB18030",
      "jingdong"  => "GB18030",
      "newegg"    => "GB18030",
      "tmall"     => "GB18030",
      "suning"    => "UTF-8",
      "gome"      => "UTF-8",
      "coo8"      => "GBK",
      "yihaodian" => "UTF-8",
      "vancl" => "UTF-8",
      "mart" => "UTF-8",
      "orange" => "UTF-8",
      "yidianda" => "UTF-8",
      "redbaby" => "UTF-8",
      "dangdangbook" => "GB2312",
      "letao" => "UTF-8",
      "binggo" => "UTF-8",
      "jingdongbook"  => "GB18030",
      "letao" => "UTF-8",
      "vjia" => "UTF-8",
      "amazon" => "UTF-8",
      "tuniu" => "UTF-8",
      "tuniuhotel" => "UTF-8",
	  "tuniutour" => "UTF-8",
	  "tuniumenpiao" => "UTF-8",
	  "tuniuyoulun" => "UTF-8",
      "amazonbook" => "UTF-8",
      "mengbasha" => "UTF-8",
	    "pb89" => "UTF-8",
      "winxuan" => "UTF-8",
	  "okbuy" => "UTF-8",
	  "hcyxbook" => "GB18030",
     "misslele" => "UTF-8",
	 "bailingke" => "GBK",
   "ubao" => "UTF-8",
   "onecar" => "GB2312",
   "guguwang" => "UTF-8"
    }


    def self.set_utf8_html(item, html)
      origin_encoding = Map[item.kind]
      item.html = html.force_encoding(origin_encoding).encode("UTF-8",  :undef => :replace, :replace => "?", :invalid => :replace)
      return item
    end
  end
end
