# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/logger")

module Spider
  class Digger
    include Spider::Logger
  end
  autoload :DangdangDigger,           File.join(File.dirname(__FILE__), "digger", "dangdang_digger")
  autoload :JingdongDigger,           File.join(File.dirname(__FILE__), "digger", "jingdong_digger")
  autoload :TaobaoDigger,	      File.join(File.dirname(__FILE__), "digger", "taobao_digger")
  autoload :TmallDigger,              File.join(File.dirname(__FILE__), "digger", "tmall_digger")
  autoload :NeweggDigger,             File.join(File.dirname(__FILE__), "digger", "newegg_digger")
  autoload :SuningDigger,             File.join(File.dirname(__FILE__), "digger", "suning_digger")
  autoload :GomeDigger,               File.join(File.dirname(__FILE__), "digger", "gome_digger")
  autoload :Coo8Digger,               File.join(File.dirname(__FILE__), "digger", "coo8_digger")
  autoload :YihaodianDigger,          File.join(File.dirname(__FILE__), "digger", "yihaodian_digger")
  autoload :VanclDigger,              File.join(File.dirname(__FILE__), "digger", "vancl_digger")
  autoload :MartDigger,              File.join(File.dirname(__FILE__), "digger", "mart_digger")
  autoload :OrangeDigger,              File.join(File.dirname(__FILE__), "digger", "orange_digger")
  autoload :YidiandaDigger,              File.join(File.dirname(__FILE__), "digger", "yidianda_digger")
  autoload :RedbabyDigger,            File.join(File.dirname(__FILE__), "digger", "redbaby_digger")
  autoload :DangdangbookDigger,       File.join(File.dirname(__FILE__), "digger", "dangdangbook_digger")
  autoload :JingdongbookDigger,       File.join(File.dirname(__FILE__), "digger", "jingdongbook_digger")
  autoload :LetaoDigger,           File.join(File.dirname(__FILE__), "digger", "letao_digger")
  autoload :BinggoDigger,           File.join(File.dirname(__FILE__), "digger", "binggo_digger")
  autoload :VjiaDigger,           		File.join(File.dirname(__FILE__), "digger", "vjia_digger")
  autoload :AmazonDigger,           		File.join(File.dirname(__FILE__), "digger", "amazon_digger")
  autoload :TuniuDigger,           		File.join(File.dirname(__FILE__), "digger", "tuniu_digger")
  autoload :AmazonbookDigger,           		File.join(File.dirname(__FILE__), "digger", "amazonbook_digger")
  autoload :MengbashaDigger,           		File.join(File.dirname(__FILE__), "digger", "mengbasha_digger")
  autoload :Pb89Digger,              File.join(File.dirname(__FILE__), "digger", "pb89_digger")
  autoload :WinxuanDigger,              File.join(File.dirname(__FILE__), "digger", "winxuan_digger")
  autoload :OkbuyDigger,              File.join(File.dirname(__FILE__), "digger", "okbuy_digger")
  autoload :HcyxbookDigger,              File.join(File.dirname(__FILE__), "digger", "hcyxbook_digger")
  autoload :TuniuhotelDigger,           		File.join(File.dirname(__FILE__), "digger", "tuniuhotel_digger")
  autoload :TuniutourDigger,           		File.join(File.dirname(__FILE__), "digger", "tuniutour_digger")
  autoload :MissleleDigger,           		File.join(File.dirname(__FILE__), "digger", "misslele_digger")
  autoload :TuniumenpiaoDigger,           		File.join(File.dirname(__FILE__), "digger", "tuniumenpiao_digger")
  autoload :TuniuyoulunDigger,           		File.join(File.dirname(__FILE__), "digger", "tuniuyoulun_digger")
  autoload :BailingkeDigger,           		File.join(File.dirname(__FILE__), "digger", "bailingke_digger")
  autoload :UbaoDigger,           		File.join(File.dirname(__FILE__), "digger", "ubao_digger")
  autoload :OnecarDigger,           		File.join(File.dirname(__FILE__), "digger", "onecar_digger")
  autoload :GuguwangDigger,           		File.join(File.dirname(__FILE__), "digger", "guguwang_digger")
end
