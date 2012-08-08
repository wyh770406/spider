# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/logger")

module Spider
  class Paginater 
    include Spider::Logger
  end
  
  autoload :DangdangPaginater,    File.join(File.dirname(__FILE__), "paginater", "dangdang_paginater")
  autoload :JingdongPaginater,    File.join(File.dirname(__FILE__), "paginater", "jingdong_paginater")
  autoload :TaobaoPaginater,      File.join(File.dirname(__FILE__), "paginater", "taobao_paginater")
  autoload :TmallPaginater,       File.join(File.dirname(__FILE__), "paginater", "tmall_paginater")
  autoload :NeweggPaginater,      File.join(File.dirname(__FILE__), "paginater", "newegg_paginater")
  autoload :GomePaginater,        File.join(File.dirname(__FILE__), "paginater", "gome_paginater")
  autoload :SuningPaginater,      File.join(File.dirname(__FILE__), "paginater", "suning_paginater")
  autoload :Coo8Paginater,        File.join(File.dirname(__FILE__), "paginater", "coo8_paginater")
  autoload :YihaodianPaginater,   File.join(File.dirname(__FILE__), "paginater", "yihaodian_paginater")
  autoload :VanclPaginater,       File.join(File.dirname(__FILE__), "paginater", "vancl_paginater")
  autoload :MartPaginater,       File.join(File.dirname(__FILE__), "paginater", "mart_paginater")
  autoload :OrangePaginater,       File.join(File.dirname(__FILE__), "paginater", "orange_paginater")
  autoload :YidiandaPaginater,       File.join(File.dirname(__FILE__), "paginater", "yidianda_paginater")
  autoload :RedbabyPaginater,     File.join(File.dirname(__FILE__), "paginater", "redbaby_paginater")
  autoload :DangdangbookPaginater,    File.join(File.dirname(__FILE__), "paginater", "dangdangbook_paginater")
  autoload :JingdongbookPaginater,    File.join(File.dirname(__FILE__), "paginater", "jingdongbook_paginater")
  autoload :LetaoPaginater,       File.join(File.dirname(__FILE__), "paginater", "letao_paginater")
  autoload :BinggoPaginater,       File.join(File.dirname(__FILE__), "paginater", "binggo_paginater")
  autoload :VjiaPaginater,       	File.join(File.dirname(__FILE__), "paginater", "vjia_paginater")
  autoload :AmazonPaginater,       	File.join(File.dirname(__FILE__), "paginater", "amazon_paginater")
  autoload :TuniuPaginater,       	File.join(File.dirname(__FILE__), "paginater", "tuniu_paginater")
  autoload :AmazonbookPaginater,       	File.join(File.dirname(__FILE__), "paginater", "amazonbook_paginater")
  autoload :MengbashaPaginater,       	File.join(File.dirname(__FILE__), "paginater", "mengbasha_paginater")
  autoload :Pb89Paginater,        File.join(File.dirname(__FILE__), "paginater", "pb89_paginater")
  autoload :WinxuanPaginater,        File.join(File.dirname(__FILE__), "paginater", "winxuan_paginater")
  autoload :OkbuyPaginater,        File.join(File.dirname(__FILE__), "paginater", "okbuy_paginater")
  autoload :HcyxbookPaginater,        File.join(File.dirname(__FILE__), "paginater", "hcyxbook_paginater")
  autoload :TuniuhotelPaginater,       	File.join(File.dirname(__FILE__), "paginater", "tuniuhotel_paginater")
  autoload :TuniutourPaginater,       	File.join(File.dirname(__FILE__), "paginater", "tuniutour_paginater")
  autoload :MisslelePaginater,       	File.join(File.dirname(__FILE__), "paginater", "misslele_paginater")
  autoload :TuniumenpiaoPaginater,       	File.join(File.dirname(__FILE__), "paginater", "tuniumenpiao_paginater")
  autoload :TuniuyoulunPaginater,       	File.join(File.dirname(__FILE__), "paginater", "tuniuyoulun_paginater")
  autoload :BailingkePaginater,       	File.join(File.dirname(__FILE__), "paginater", "bailingke_paginater")
  autoload :UbaoPaginater,       	File.join(File.dirname(__FILE__), "paginater", "ubao_paginater")
  autoload :OnecarPaginater,       	File.join(File.dirname(__FILE__), "paginater", "onecar_paginater")
  autoload :GuguwangPaginater,       	File.join(File.dirname(__FILE__), "paginater", "guguwang_paginater")
end

